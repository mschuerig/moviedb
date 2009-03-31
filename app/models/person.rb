class Person < ActiveRecord::Base
  class HasRoleError < StandardError; end

  attr_readonly :serial_number
  
  validates_presence_of :firstname, :lastname

  has_many :roles, :include => :role_type
  
  module RoleTypeExtensions
    RoleType.each_name do |name|
      define_method("as_#{name}") do
        self.scoped(
          :joins => 'INNER JOIN role_types ON roles.role_type_id = role_types.id',
          :conditions => { :role_types => { :name => name } })
      end
    end
  end
  
  has_many :movies, :through => :roles, :extend => RoleTypeExtensions, :order => 'release_date'
  
  has_and_belongs_to_many :awardings

  default_scope :order => 'lastname, firstname, serial_number'
  
  RoleType.each_name do |name|
    named_scope name.pluralize, lambda { |*args|
      options = args.first || {}
      role_condition = { :role_types => { :name => name }}
      if movies = (options[:movie] || options[:movies])
        role_condition[:movie_id] = movies
      end
      {
        :joins => ['INNER JOIN roles ON roles.person_id = people.id',
                   'INNER JOIN role_types ON roles.role_type_id = role_types.id'],
        :conditions => { :roles => role_condition }
      }
    }
  end
  
  named_scope :participating_in_movie, lambda { |movie|
    {
      :joins => 'INNER JOIN roles ON roles.person_id = people.id',
      :conditions => { :roles => { :movie_id => movie }}
    }
  }
  
  named_scope :with_movie_in_year, lambda { |year|
    {
      :joins => ['INNER JOIN roles ON roles.person_id = people.id',
                 'INNER JOIN movies ON roles.movie_id = movies.id'],
      :conditions => Movie.in_year_condition(year)
    }
  }
  
  def name
    if has_dupes?
      "#{firstname} #{lastname} (#{serial_number})" ### TODO use roman numeral
    else
      "#{firstname} #{lastname}"
    end
  end
  
  def credits_name
    "#{firstname} #{lastname}"
  end
  
  def coworkers(options = {})
    if movie = options[:movie]
      Person.scoped(
        :conditions => [
          "people.id <> ? AND people.id IN" +
          " (SELECT roles.person_id FROM roles WHERE roles.movie_id = ?)",
          id, movie
        ]
      )
    else
      Person.scoped(
        :conditions => [
        "people.id <> ? AND people.id IN" +
        " (SELECT roles.person_id FROM roles WHERE roles.movie_id IN" +
        " (SELECT roles.movie_id from roles WHERE roles.person_id = ?))",
        id, id]
      )
    end
  end

  def self.find(*args)
    args = args.dup
    options = args.extract_options!
    if options[:order] =~ /\bname\b( (ASC|DESC))?/i
      options[:order] = "lastname#{$1},firstname#{$1},serial_number#{$1}"
    end
    unless options[:group] || options[:select]
      options[:select] = 'people.*, (SELECT COUNT(*) FROM PEOPLE AS dupe WHERE dupe.lastname = people.lastname AND dupe.firstname = people.firstname) as duplicate_count'
    end
    args << options
    super(*args)
  end

  def before_create
    # This method is called before create and before a retried create.
    # On a retry, serial_number is already set, so don't reset it.
    self.serial_number ||= 1
    self[:duplicate_count] ||= 0
    self[:duplicate_count] += 1
  end
  
  def before_destroy
    raise HasRoleError unless roles.empty?
  end
  
  private
  
  def create_or_update
    super
  rescue ActiveRecord::StatementInvalid => e
    if e.message.include?('are not unique')
      self.serial_number = next_unused_serial_number
      retry
    else
      raise
    end
  end
  
  def has_dupes?
    self[:duplicate_count].to_i > 1
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
