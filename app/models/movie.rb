class Movie < ActiveRecord::Base
  attr_protected :release_year

  acts_as_xapian :texts => [ :title, :summary ],
    :values => [ [ :release_year, 1, 'year', :number ] ]

  validates_presence_of :title

  has_many :roles, :include => :role_type, :dependent => :destroy

  module ParticipantTypeExtensions
    include RoleTypeAssociationExtensions

    ### TODO how to ensure that the new participant is seen before saving?
    def add(role_name, person, options = {})
      proxy_owner.roles.build(
        :person => person,
        :role_type => RoleType[role_name],
        :credited_as => options[:as]
      )
    end

    def remove(role_name, person)
      role = Role.find(:first,
        :joins => :role_type,
        :conditions => {
          :person_id => person,
          :movie_id  => proxy_owner,
          :role_types => { :name => role_name.to_s }
        })
      proxy_owner.roles.delete(role)
    end

    def replace(role, others)
      transaction do
        ### TODO merge credited_as
        others  = Person.find(others.map { |a| normalize_person_ref(a) })
        current = proxy_owner.participants.as_actor

        obsolete = current.select { |o| !others.include?(o) }
        fresh    = others.select  { |o| !current.include?(o) }

        obsolete.each { |o| self.remove(role, o) }
        fresh.each    { |o| self.add(role, o) }
      end
    end

    RoleType.each_name do |name|
      class_eval <<-END
        def add_#{name}(person, options = {})
          add(:#{name}, person, options)
        end
        def remove_#{name}(person)
          remove(:#{name}, person)
        end
        def replace_#{name.pluralize}(others)
          replace(:#{name}, others)
        end
      END
    end

    private

    def normalize_person_ref(ref)
      case ref
      when Hash
        normalize_person_ref(ref['$ref'])
      when String
        ref.sub('/people/', '')
      else
        ref
      end
    end
  end

  has_many :participants, :through => :roles, :source => :person, :extend => ParticipantTypeExtensions

  has_and_belongs_to_many :awardings, :after_remove => lambda { |_, awarding| awarding.destroy }

  default_scope :order => 'title, release_date'

  def self.in_year_condition(year)
    ["movies.release_year = ?",year]
  end

  named_scope :in_year,
    lambda { |year| { :conditions => in_year_condition(year) } }

  def self.by_year
    find(:all).group_by(&:release_year).sort_by(&:first)
  end

  def self.find(*args)
    options = args.extract_options!
    if options[:order] =~ /\bawards\b/i
      tn = table_name
      cols = Movie.column_names.map { |c| "#{tn}.#{c}"}.join(',')
      with_scope(:find => options) do
        super(args[0],
          :select => "#{cols}, COUNT(awardings_movies.movie_id) AS awards",
          :joins => "LEFT OUTER JOIN awardings_movies ON awardings_movies.movie_id = movies.id",
          :group => cols
        )
      end
    else
      args << options
      super(*args)
    end
  end


  def actors
    participants.as_actor
  end

  def actors=(others)
    participants.replace_actors(others)
  end


  def before_save
    self.release_year = release_date.blank? ? nil : release_date.year
  end
end
