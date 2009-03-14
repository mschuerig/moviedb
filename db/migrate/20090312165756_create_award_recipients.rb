class CreateAwardRecipients < ActiveRecord::Migration
  def self.up
    create_table :awardings_people, :id => false do |t|
      t.belongs_to :awarding, :null => false
      t.belongs_to :person, :null => false
    end
    add_index :awardings_people, [:awarding_id, :person_id], :unique => true
    add_index :awardings_people, :person_id

    create_table :awardings_movies, :id => false do |t|
      t.belongs_to :awarding, :null => false
      t.belongs_to :movie, :null => false
    end
    add_index :awardings_movies, [:awarding_id, :movie_id], :unique => true
    add_index :awardings_movies, :movie_id
  end

  def self.down
    drop_table :awardings_people
    drop_table :awardings_movies
  end
end
