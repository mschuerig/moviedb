class MovieAwarding < ActiveRecord::Base
  validates_presence_of :year, :movie_award, :movie
  belongs_to :movie
  belongs_to :movie_award, :include => :award_group
  
  def name
    "#{movie_award.full_name} (#{year})"
  end
  
  def before_validation
    self.year ||= movie.release_year if movie
  end
end
