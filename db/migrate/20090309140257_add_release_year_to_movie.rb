class AddReleaseYearToMovie < ActiveRecord::Migration
  def self.up
    add_column :movies, :release_year, :integer
    fix_years
  end

  def self.down
    remove_column :movies, :release_year
  end
  
  private
  
  def self.fix_years
    Movie.each do |m|
      if m.release_date
        m.release_year = m.release_date.year
        m.save!
      end
    end
  end
end
