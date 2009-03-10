class CreateMovieAwardings < ActiveRecord::Migration
  def self.up
    create_table :movie_awardings do |t|
      t.integer :year, :null => false
      t.belongs_to :movie_award, :null => false
      t.belongs_to :movie, :null => false
      t.timestamps
    end
    add_index :movie_awardings, [:movie_id, :year, :movie_award_id], :unique => true
    add_index :movie_awardings, :movie_award_id
  end

  def self.down
    drop_table :movie_awardings
  end
end
