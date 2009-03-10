class AwardGroup < ActiveRecord::Base
  validates_presence_of :name
  has_many :movie_awards
  has_many :person_awards
end
