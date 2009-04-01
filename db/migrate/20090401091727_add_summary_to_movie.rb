class AddSummaryToMovie < ActiveRecord::Migration
  def self.up
    add_column :movies, :summary, :text
  end

  def self.down
    remove_column :movies, :summary
  end
end
