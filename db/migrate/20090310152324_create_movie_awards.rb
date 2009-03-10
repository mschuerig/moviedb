class CreateMovieAwards < ActiveRecord::Migration
  def self.up
    create_table :movie_awards do |t|
      t.string :name, :null => false
      t.belongs_to :award_group, :null => false
      t.timestamps
    end
    add_index :movie_awards, :name, :unique => true
  end

  def self.down
    drop_table :movie_awards
  end
end
