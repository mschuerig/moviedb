class MovieRole < ActiveRecord::Base
  validates_presence_of :person_id
  validates_presence_of :role_id
  validates_presence_of :movie_id
end
