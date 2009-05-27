
class Marriage < ActiveRecord::Base
  belongs_to :person, :touch => true
  belongs_to :spouse, :class_name => 'Person', :touch => true
  attr_readonly :person_id, :spouse_id
  validates_presence_of :person, :spouse, :start_date

  named_scope :started_before, lambda { |date|
    { :conditions => ["start_date < ?", date] }
  }

  named_scope :ended_before, lambda { |date|
    { :conditions => ["COALESCE(end_date, NOW()) < ?", date] }
  }

  named_scope :started_after, lambda { |date|
    { :conditions => ["? < start_date", date] }
  }

  named_scope :ended_after, lambda { |date|
    { :conditions => ["? < COALESCE(end_date, NOW())", date] }
  }

  named_scope :during, lambda { |options|
    dates   = SqlHelper.dates_from_options(options)
    overlap = SqlHelper.overlaps_predicate(:from_date, :until_date, 'start_date', 'COALESCE(end_date, NOW())')
    { :conditions => [overlap, dates] }
  }

  def before_validation
    self.start_date ||= Date.today
  end

  def validate_on_create
    if person == spouse
      errors.add_to_base("A person cannot marry themselves.")
    end
  end

  def validate
    if end_date && end_date < start_date
      errors.add(:end_date, "The end date cannot be before the start date.")
    end

    validate_unmarried(person, :person_id)
    validate_unmarried(spouse, :spouse_id)
  end

  private

  named_scope :excluding, lambda { |marriage|
    marriage.new_record? ? {} : { :conditions => ["marriages.id <> ?", marriage] }
  }

  def validate_unmarried(person, attribute)
    # TODO do this check on loaded association collection?
    married = person.marriages.excluding(self).during(:from => start_date, :until => end_date).exists?
    if married
      errors.add(attribute, "Is already married at that time.")
    end
  end
end
