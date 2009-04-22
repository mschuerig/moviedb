class NoAwardGroups < ActiveRecord::Migration
  def self.up
    change_table :awards do |t|
      t.boolean :awardable
      t.belongs_to :parent, :foreign_key => :parent_id
      t.change :award_group_id, :integer
    end
    
    execute "UPDATE awards SET awardable = true"
    change_column :awards, :awardable, :boolean, :null => false
    
    change_column :awards, :award_group_id, :integer, :null => true
    execute "INSERT INTO awards (name, awardable) (SELECT name, false FROM award_groups)"
    execute <<SQL
UPDATE awards AS a SET parent_id = 
  (SELECT p.id FROM awards AS p JOIN award_groups AS g ON g.name = p.name WHERE g.id = a.award_group_id)
SQL
    remove_column :awards, :award_group_id
    drop_table :award_groups
  end

  def self.down
    create_table :award_groups do |t|
      t.string :name, :null => false
      t.timestamps
    end
    
    execute "INSERT INTO award_groups (name) (SELECT name FROM awards WHERE parent_id IS NULL)"
    add_column :awards, :award_group_id, :integer
    execute <<SQL
UPDATE awards AS a SET award_group_id =
  (SELECT g.id FROM award_groups AS g JOIN awards AS p ON g.name = p.name WHERE p.id = a.parent_id)
SQL
    execute "DELETE FROM awards WHERE parent_id IS NULL)"
    
    change_column :awards, :award_group_id, :integer, :null => false
    remove_column :awards, :awardable
    add_index :award_groups, :name, :unique => true
  end
end
