
class Marriage < ActiveRecord::Base
  belongs_to :person
  belongs_to :spouse, :class_name => 'Person'
  attr_readonly :person_id, :spouse_id
  validates_presence_of :person_id, :spouse_id
  
  def before_validation
    self.start_date ||= Date.today
  end
  
  def validate_on_create
    if person == spouse
      errors.add_to_base("A person cannot marry themselves.")
    end
    if person.spouse
      errors.add(:person_id, "Is already married") 
    end
    if spouse.spouse
      errors.add(:spouse_id, "Is already married") 
    end
  end
end
