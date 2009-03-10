class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.string :title, :null => false
      t.date :release_date
      t.integer :release_year
      t.timestamps
    end
    add_index :movies, :title
  end

  def self.down
    drop_table :movies
  end
end
