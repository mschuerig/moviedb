class PersonAwarding < ActiveRecord::Base
  validates_presence_of :year, :person, :movie, :person_award
  belongs_to :person
  belongs_to :movie
  belongs_to :person_award, :include => :award_group

  def name
    "#{person_award.full_name} (#{year})"
  end

  def before_validation
    self.year ||= movie.release_year if movie
  end
end
