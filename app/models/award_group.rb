class AwardGroup < ActiveRecord::Base
  validates_presence_of :name
  has_many :awards
  
  default_scope :order => 'name'

  def children
    awards
  end
end
