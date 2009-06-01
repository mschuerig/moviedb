class CreateMovieItems < ActiveRecord::Migration
  def self.up
    create_view :movie_items,
        %{SELECT id, title, release_date, release_year, created_at, updated_at, lock_version, COUNT(awardings_movies.movie_id) AS award_count
          FROM movies
          LEFT OUTER JOIN awardings_movies ON awardings_movies.movie_id = movies.id
          GROUP BY id, title, release_date, release_year, created_at, updated_at, lock_version
         } do |v|
      v.column :id
      v.column :title
      v.column :release_date
      v.column :release_year
      v.column :award_count
      v.column :created_at
      v.column :updated_at
      v.column :lock_version
    end
  end

  def self.down
    drop_view :movie_items
  end
end
