
class Marriage < ActiveRecord::Base
  belongs_to :person, :touch => true
  belongs_to :spouse, :class_name => 'Person', :touch => true
  attr_readonly :person_id, :spouse_id
  validates_presence_of :person_id, :spouse_id, :start_date
  
  def before_validation
    self.start_date ||= Date.today
  end
  
  def validate_on_create
    if person == spouse
      errors.add_to_base("A person cannot marry themselves.")
    end
  end
  
  def validate_on_save
    if end_date && end_date < start_date
      errors.add(:end_date, "The end date cannot be before the start date.")
    end

    validate_unmarried(person, :person_id)
    validate_unmarried(spouse, :spouse_id)
  end

  private
  
  def update(*args)
    # This scoping ensures that UPDATE only reports changing one row (at the most)
    # and thus a spurious clash with optimistic locking is avoided.
    self.class.send(:with_scope, :find => { :conditions => "person_id < spouse_id" }) do
      super
    end
  end

  def validate_unmarried(person, attribute)
    if person.marriages.during(:from => start_date, :until => end_date).exists?
      errors.add(attribute, "Is already married at that time.")
    end
  end
end
