class Award < ActiveRecord::Base
  validates_presence_of :name, :award_group
  belongs_to :award_group
  has_many :award_requirements, :dependent => :destroy
  
  def fullname
    "#{award_group.name}: #{name}"
  end
  
  def validate_awarding(awarding)
    award_requirements.each { |req| req.validate_awarding(awarding) }
  end
end
