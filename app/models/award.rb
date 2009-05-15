class Award < ActiveRecord::Base
  validates_presence_of :name
  acts_as_nested_set
  serialize :requirements
  belongs_to :parent, :class_name => 'Award', :foreign_key => :parent_id
  has_many :children, :class_name => 'Award', :foreign_key => :parent_id, :dependent => :destroy
  has_many :awardings, :order => 'awardings.year DESC'

  default_scope :include => :parent, :order => 'name'

  named_scope :top_level, :conditions => { :parent_id => nil }

  def self.awardize(a)
    a.kind_of?(Award) ? a : Award.find(a)
  end

  def fullname
    if parent
      "#{parent.name}: #{name}"
    else
      name
    end
  end

  def for_year(year)
    Awarding.find_by_year_and_award_id(year, self.id)
  end

  def validate_awarding(awarding)
    AwardingValidator.new(requirements).validate_awarding(awarding)
  end
end
