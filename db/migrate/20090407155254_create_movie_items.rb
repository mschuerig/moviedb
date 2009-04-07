class CreateMovieItems < ActiveRecord::Migration
  def self.up
    create_view :movie_items,
        %{SELECT id, title, release_date, COUNT(awardings_movies.movie_id) AS award_count
          FROM movies
          LEFT OUTER JOIN awardings_movies ON awardings_movies.movie_id = movies.id
          GROUP BY id, title, release_date
         } do |v|
      v.column :id
      v.column :title
      v.column :release_date
      v.column :award_count
    end
  end

  def self.down
    drop_view :movie_items
  end
end
