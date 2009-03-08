class AddRoleCreditedAs < ActiveRecord::Migration
  def self.up
    add_column :roles, :credited_as, :string
    fix_credits
    change_column :roles, :credited_as, :string, :null => false
  end

  def self.down
    remove_column :roles, :credited_as
  end
  
  private
  
  def self.fix_credits
    Role.each do |r|
      if r.credited_as.blank?
        r.credited_as = "#{r.person.firstname} #{r.person.lastname}"
        r.save!
      end
    end
  end
end
