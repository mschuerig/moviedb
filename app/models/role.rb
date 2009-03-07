class Role < ActiveRecord::Base
  validates_presence_of :person_id, :role_type_id, :movie_id
  belongs_to :person
  belongs_to :role
  belongs_to :movie
end
