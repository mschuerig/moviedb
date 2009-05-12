class Movie < ActiveRecord::Base
  attr_protected :release_year

  acts_as_xapian :texts => [ :title, :summary ],
    :values => [ [ :release_year, 1, 'year', :number ] ]

  validates_presence_of :title

  has_many :roles, :include => :role_type, :dependent => :destroy

  module ParticipantTypeExtensions
    include RoleTypeAssociationExtensions
    RoleType.each_name do |name|
      ### TODO how to ensure that the new participant is seen before saving?
      class_eval <<-END
        def add_#{name}(person, options = {})
          proxy_owner.roles.build(
            :person => person,
            :role_type => RoleType[:#{name}],
            :credited_as => options[:as]
          )
        end
      END
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

  def actors=(actors)
    debugger
    ### TODO extract; see association_collection#replace
    actor_ids = actors.map { |a| a['$ref'].sub('/people/', '') }.reject { |aid| aid.blank? }
    new_actors = Person.find(actor_ids)
    
    transaction do
      current = participants.as_actor
      participants.as_actor.delete(current.select { |a| !new_actors.include?(a) })
      participants.as_actor.concat(new_actors.select { |a| !current.include?(v) })
    end
  end
  

  def before_save
    self.release_year = release_date.blank? ? nil : release_date.year
  end
end
