class CreateRoleTypes < ActiveRecord::Migration
  def self.up
    create_table :role_types do |t|
      t.string :name, :null => false
      t.timestamps
    end
    add_index :role_types, :name, :unique => true
  end

  def self.down
    drop_table :role_types
  end
end
