class CreateCharacters < ActiveRecord::Migration
  def self.up
    create_table :characters do |t|
      t.string :name, :null => false
      t.integer :lock_version, :null => false, :default => 0
      t.timestamps
    end
    add_index :characters, :name
    
    create_table :characters_roles, :id => false do |t|
      t.belongs_to :character, :null => false
      t.belongs_to :role, :null => false
    end
    add_index :characters_roles, [:character_id, :role_id], :unique => true
  end

  def self.down
    drop_table :characters_roles
    drop_table :characters
  end
end
