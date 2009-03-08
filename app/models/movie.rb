class Movie < ActiveRecord::Base
  validates_presence_of :title
  has_many :roles, :include => :role_type, :dependent => :destroy
#  has_many :actors, :through => :roles, :source => :person,
#    :include => :role_type,
#    :conditions => { :roles => { :role_types => { :name => 'Actor' }}}
  
  RoleType.each_name do |name, clean_name|
    has_many clean_name.pluralize,
      :class_name => 'Person',
      :finder_sql => <<-SQL
SELECT people.* FROM movies
JOIN roles ON roles.movie_id = movies.id
JOIN people ON roles.person_id = people.id
JOIN role_types ON roles.role_type_id = role_types.id
WHERE movies.id = \#{id}
AND role_types.name = '#{connection.quote_string(name)}'
ORDER BY people.lastname, people.firstname
      SQL
    
    define_method("add_#{clean_name}") do |person|
      roles.build(:person => person, :role_type => RoleType.find_by_name!(name))
    end
  end
  
end
