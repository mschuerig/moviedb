
class Person
  attr_readonly :serial_number

  validates_presence_of :firstname, :lastname

  # Returns a formatted name for the person.
  # Formatting is really a view concern, this method is here only for inspection.
  def name
    if has_dupes?
      "#{firstname} #{lastname} (#{serial_number})"
    else
      "#{firstname} #{lastname}"
    end
  end

  def credits_name
    "#{firstname} #{lastname}"
  end

  def has_dupes?
    self[:duplicate_count].to_i > 1
  end

  def before_create
    # This method is called before create and before a retried create.
    # On a retry, serial_number is already set, so don't reset it.
    self.serial_number ||= 1
    self[:duplicate_count] ||= 0
    self[:duplicate_count] += 1
  end

  private

  def create_or_update
    Person.transaction(:requires_new => true) do
      # The nested transaction is required as otherwise the failing
      # INSERT aborts the entire (outer) transaction.
      super
    end
  rescue ActiveRecord::RecordNotUnique => e
    self.serial_number = next_unused_serial_number
    retry
  end

  def next_unused_serial_number
    self.class.next_unused_serial_number(self)
  end

  def self.next_unused_serial_number(person)
    max = self.maximum(:serial_number,
      :conditions => { :lastname => person.lastname, :firstname => person.firstname })
    max ? max + 1 : 1
  end
end