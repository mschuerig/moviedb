class Person < ActiveRecord::Base
  class HasRoleError < StandardError; end

  has_many :roles, :include => :role_type

  RoleType.each_name do |name, clean_name|
#     has_many "#{clean_name}_of", :through => :roles, :source => :movie,
#     :order => 'release_date',
#     :include => :role_type,
#     :conditions => { :roles => { :role_types => { :name => name } } }
    has_many "#{clean_name}_of",
      :class_name => 'Movie',
      :finder_sql => <<-SQL
SELECT movies.* FROM people
JOIN roles ON roles.person_id = people.id
JOIN movies ON roles.movie_id = movies.id
JOIN role_types ON roles.role_type_id = role_types.id
WHERE people.id = \#{id}
AND role_types.name = '#{connection.quote_string(name)}'
ORDER BY release_date
      SQL
    
    named_scope clean_name.pluralize,
      :order => 'lastname, firstname',
      :joins => { :roles => :role_type },
      :conditions => { :roles => { :role_types => { :name => name }}}
  end
  
  validates_presence_of :firstname, :lastname
  

  def before_destroy
    raise HasRoleError unless roles.empty?
  end
end
