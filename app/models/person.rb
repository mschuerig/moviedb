class Person < ActiveRecord::Base
  class HasRoleError < StandardError; end

  attr_readonly :serial_number
  
  validates_presence_of :firstname, :lastname

  has_many :roles, :include => :role_type
  
  module RoleTypeExtensions
    RoleType.each_name do |name, clean_name|
      define_method("as_#{clean_name}") do
        self.scoped(
          :joins => 'JOIN role_types ON roles.role_type_id = role_types.id',
          :conditions => { :role_types => { :name => name }})
      end
    end
  end
  
  has_many :movies, :through => :roles, :extend => RoleTypeExtensions, :order => 'release_date'
  
  has_and_belongs_to_many :awardings
  
  default_scope :order => 'lastname, firstname'
  
  RoleType.each_name do |name, clean_name|
    named_scope clean_name.pluralize,
      :joins => { :roles => :role_type },
      :conditions => { :roles => { :role_types => { :name => name }}}
  end
  
  named_scope :with_movie_in_year, lambda { |year|
    {
      :joins => { :roles => :movie },
      :conditions => Movie.in_year_condition(year)
    }
  }
  
  def create(*args)
    super(*args)
  rescue ActiveRecord::StatementInvalid => e
    if e.message.include?('are not unique')
      self.serial_number = next_unused_serial_number
      retry
    else
      raise
    end
  end
  
  def name
    if has_dupes?
      "#{firstname} #{lastname} (#{serial_number})" ### TODO use roman numeral
    else
      "#{firstname} #{lastname}"
    end
  end

  def coworkers(movie = nil)
    if movie
      others = movie.participants
    else
      others = Person.find(:all,
        :conditions => ["people.id IN (SELECT roles.person_id FROM roles WHERE roles.movie_id IN (SELECT roles.movie_id from roles WHERE roles.person_id = ?))", id]
      )
    end
    others.include?(self) ? others - [self] : []
  end
  
  def before_create
    # This method is called before create and before a retried create.
    # On a retry, serial_number is already set, so don't reset it.
    self.serial_number ||= 1
  end
  
  def before_destroy
    raise HasRoleError unless roles.empty?
  end
  
  private
  
  def has_dupes?
    true
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
