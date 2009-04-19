class Award < ActiveRecord::Base
  validates_presence_of :name, :award_group
  belongs_to :award_group
  has_many :requirements, :class_name => 'AwardRequirement', :dependent => :destroy
  has_many :awardings, :order => 'awardings.year DESC'
  
  default_scope :include => :award_group, :order => 'name'
  
  def fullname
    "#{award_group.name}: #{name}"
  end
  
  def for_year(year)
    Awarding.find_by_year_and_award_id(year, self.id)
  end
  
  def validate_awarding(awarding)
    requirements.each { |req| req.validate_awarding(awarding) }
  end
  
  def children
    []
  end
end
