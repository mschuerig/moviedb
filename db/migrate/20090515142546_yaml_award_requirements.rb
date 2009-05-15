class YamlAwardRequirements < ActiveRecord::Migration
  def self.up
    add_column :awards, :requirements, :text
    
    Award.all.each do |award|
      reqs = award.requirements.inject([]) { |memo, rq|
        hash = { :association => rq.association, :count => rq.count }
        hash[:role] = rq.role_type.name if rq.role_type
        memo << hash
      }
      execute "UPDATE awards SET requirements = '#{reqs.to_yaml}' WHERE id = #{award.id}"
    end
    
    drop_table :award_requirements
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
