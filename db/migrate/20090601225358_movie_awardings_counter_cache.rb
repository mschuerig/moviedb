class MovieAwardingsCounterCache < ActiveRecord::Migration
  def self.up
    drop_view :movie_items
    change_table :movies do |t|
      t.integer :awardings_count, :null => false, :default => 0
    end
    execute %{UPDATE movies SET awardings_count = (SELECT COUNT(*) FROM awardings_movies WHERE movie_id = movies.id)}
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
