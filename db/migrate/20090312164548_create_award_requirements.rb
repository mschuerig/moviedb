class CreateAwardRequirements < ActiveRecord::Migration
  def self.up
    create_table :award_requirements do |t|
      t.belongs_to :award, :null => false
      t.string :required_type, :null => false
      t.timestamps
    end
    
    add_index :award_requirements, [:award_id, :required_type], :unique => true
  end

  def self.down
    drop_table :award_requirements
  end
end
