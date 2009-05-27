
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

  def overlaps?(dates)
    today = Date.today
    from_date  = extract_date(dates, [:from,  :date], today)
    until_date = extract_date(dates, [:until, :date], today)
    (from_date..until_date).overlaps?((start_date || today)..(end_date || today))
  end

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

=begin
 named_scope :excluding, lambda { |marriage|
    marriage.new_record? ? {} : { :conditions => ["marriages.id <> ?", marriage] }
  }
=end

  def validate_unmarried(person, attribute)
#    married = person.marriages.excluding(self).during(:from => start_date, :until => end_date).exists?
    married = !(person.marriages.during(:from => start_date, :until => end_date) - [self]).empty?
    if married
      errors.add(attribute, "Is already married at that time.")
    end
  end

  def extract_date(hash, keys, default_date)
    date = extract_value(hash, keys, default_date)
    date = Date.parse(date) if date.kind_of?(String)
    date.to_date
  end

  def extract_value(hash, keys, default_value)
    key = keys.detect { |k| hash[k] }
    key ? hash[key] : default_value
  end
end
