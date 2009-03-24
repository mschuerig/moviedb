class Awarding < ActiveRecord::Base
  validates_presence_of :award, :year
  belongs_to :award
  has_and_belongs_to_many :people
  has_and_belongs_to_many :movies
  
  def name
    "#{award.fullname} (#{year})"
  end
  
  def validate
    award.try(:validate_awarding, self)
  end
  
  def before_validation
    if year.blank?
      if movie = single_movie
        self.year = movie.release_year
      end
    end
  end
  
  def single_movie
    return movies[0] if movies.size == 1
  end
end
