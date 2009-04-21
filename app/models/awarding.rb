class Awarding < ActiveRecord::Base
  validates_presence_of :award, :year
  belongs_to :award
  
  module PeopleExtensions
    define_method("as") do |role_name|
      return self if role_name.blank?
      role_name = role_name.kind_of?(RoleType) ? role_name.name : role_name.to_s
      self.scoped(
        # PostgreSQL doesn't allow forward references to joined tables.
        # Unfortunately, ActiveRecord merges the many scoped joins
        # in an unsuitable order.
        # We'll work around this with a CROSS JOIN + WHERE clause.
        #:joins => 'INNER JOIN role_types ON roles.role_type_id = role_types.id',
        #:conditions => { :role_types => { :name => role_name } })
        :joins => [ 'CROSS JOIN role_types',
                    'CROSS JOIN awardings_movies' ],
        :conditions => [%{
awardings_movies.awarding_id = awardings_people.awarding_id AND
awardings_movies.movie_id = roles.movie_id AND
roles.role_type_id = role_types.id AND 
role_types.name = ?},
                        role_name]
      )
    end
    include RoleTypeAssociationExtensions::Shortcuts
  end
  
  has_and_belongs_to_many :people, :include => :roles, :extend => PeopleExtensions
  has_and_belongs_to_many :movies
  
  named_scope :for_award, lambda { |award|
    {
      :joins => :award,
      :conditions => { :award_id => award }
    }
  }
  
  def name
    "#{award.fullname} (#{year})"
  end
  
  def requirements
    award ? award.requirements : []
  end
  
  def validate
    award.try(:validate_awarding, self)
  end
  
  def before_validation
    if year.blank?
      if movie = single_movie
        self.year = movie.release_year
      end
    end
  end
  
  def after_find
    readonly!
  end
  
  def single_movie
    return movies[0] if movies.size == 1
  end

  private
  
  def create_or_update
    Awarding.transaction(:requires_new => true) do
      # The nested transaction is required as otherwise the failing
      # INSERT aborts the entire (outer) transaction.
      super
    end
  rescue ActiveRecord::RecordNotUnique => e
    errors.add_to_base('The award can only be given once per year.')
    false
  end

end
