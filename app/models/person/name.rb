
class Person
  attr_protected :serial_number, :duplicate_count
  before_save :before_save_with_changed_name
  before_create :before_create_with_new_name
  after_save :after_save_with_changed_name

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
    duplicate_count > 1
  end

  private

  def before_save_with_changed_name
    if !@name_changed && (firstname_changed? || lastname_changed?)
      @name_changed  = true
      @old_firstname = firstname_was
      @old_lastname  = lastname_was
      # This method is called before save and before a retried save.
      # On a retry, serial_number is already set, so don't reset it.
      self.duplicate_count = self.serial_number = 1
    end
  end
  
  def before_create_with_new_name
    @name_changed  = true
  end
  
  def after_save_with_changed_name
    if @name_changed
      if @old_lastname || @old_firstname
        update_duplicate_count(@old_lastname || lastname, @old_firstname || firstname)
      end
      update_duplicate_count(lastname, firstname)
    end
  end

  def create_or_update
    Person.transaction(:requires_new => true) do
      # The nested transaction is required as otherwise the failing
      # INSERT aborts the entire (outer) transaction.
      super
    end
  rescue ActiveRecord::RecordNotUnique => e
    self.serial_number = self.duplicate_count = next_unused_serial_number
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
  
  def update_duplicate_count(lastname, firstname)
    self.class.update_duplicate_count(lastname, firstname)
  end
  
  def self.update_duplicate_count(lastname, firstname)
    Person.update_all(
      ['duplicate_count = (SELECT COUNT(id) FROM people WHERE (lastname, firstname) = (?, ?))',
      lastname, firstname])
  end
end
