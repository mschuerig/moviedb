class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.integer :role_type_id, :null => false
      t.integer :person_id, :null => false
      t.integer :movie_id, :null => false

      t.timestamps
    end
    add_index :roles, [:movie_id, :person_id, :role_type_id], :unique => true
    add_index :roles, :person_id
  end

  def self.down
    drop_table :roles
  end
end
