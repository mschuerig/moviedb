class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.belongs_to :role_type, :null => false
      t.belongs_to :person, :null => false
      t.belongs_to :movie, :null => false
      t.string :credited_as, :null => false
      t.timestamps
    end
    add_index :roles, [:movie_id, :person_id, :role_type_id], :unique => true
    add_index :roles, :person_id
  end

  def self.down
    drop_table :roles
  end
end
