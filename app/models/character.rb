class Character < ActiveRecord::Base
  validates_presence_of :name
  has_and_belongs_to_many :roles
#  has_many :movies, :through => :roles
#  has_many :actors, :through => :roles
end
