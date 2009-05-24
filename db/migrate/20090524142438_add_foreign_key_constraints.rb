
require 'migration_helpers'

class AddForeignKeyConstraints < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    foreign_key :awardings, :award_id
    foreign_key :awardings_movies, :awarding_id, :movie_id
    foreign_key :awards, :parent_id, :awards
    foreign_key :characters_roles, :character_id, :role_id
    foreign_key :roles, :role_type_id, :person_id, :movie_id
  end

  def self.down
    remove_foreign_key :awardings, :award_id
    remove_foreign_key :awardings_movies, :awarding_id
    remove_foreign_key :awardings_movies, :movie_id
    remove_foreign_key :awards, :parent_id
    remove_foreign_key :characters_roles, :character_id
    remove_foreign_key :characters_roles, :role_id
    remove_foreign_key :roles, :role_type_id
    remove_foreign_key :roles, :person_id
    remove_foreign_key :roles, :movie_id
  end
end
