class CreateMovieRoles < ActiveRecord::Migration
  def self.up
    create_table :movie_roles do |t|
      t.integer :role_id, :null => false
      t.integer :person_id, :null => false
      t.integer :movie_id, :null => false

      t.timestamps
    end
    add_index :movies, [:movie_id, :person_id, :role_id], :unique => true
    add_index :movies, :person_id
  end

  def self.down
    drop_table :movie_roles
  end
end
