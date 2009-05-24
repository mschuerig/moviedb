
class Person
  class HasRoleError < StandardError; end

  has_many :roles, :extend => RoleTypeAssociationExtensions

  has_many :movies, :through => :roles, :extend => RoleTypeAssociationExtensions, :order => 'release_date'

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

  named_scope :in_movie, lambda { |movie|
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

end
