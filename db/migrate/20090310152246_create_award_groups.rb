class CreateAwardGroups < ActiveRecord::Migration
  def self.up
    create_table :award_groups do |t|
      t.string :name, :null => false
      t.timestamps
    end
    add_index :award_groups, :name, :unique => true
  end

  def self.down
    drop_table :award_groups
  end
end
