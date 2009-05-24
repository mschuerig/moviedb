class Person < ActiveRecord::Base
  concerned_with :awards, :name, :roles, :awards
  
  default_scope :order => 'lastname, firstname, serial_number'

  def coworkers() #options = {})
=begin
    if movie = options[:movie]
      Person.scoped(
        :conditions => [
          "people.id <> ? AND people.id IN" +
          " (SELECT roles.person_id FROM roles WHERE roles.movie_id = ?)",
          id, movie
        ]
      )
    else
=end
      Person.scoped(
        :conditions => [
        "people.id <> ? AND people.id IN" +
        " (SELECT roles.person_id FROM roles WHERE roles.movie_id IN" +
        " (SELECT roles.movie_id from roles WHERE roles.person_id = ?))",
        id, id]
      )
#    end
  end

  def self.find(*args)
    args = args.dup
    options = args.extract_options!.dup
    if options[:order] =~ /\bname\b( (?:ASC|DESC))?/i
      options[:order] = "lastname#{$1},firstname#{$1},serial_number#{$1}"
    end
    unless options[:group] || options[:select]
      options[:select] = 'people.*, (SELECT COUNT(*) FROM people AS dupe WHERE dupe.lastname = people.lastname AND dupe.firstname = people.firstname) as duplicate_count'
    end
    args << options
    super(*args)
  end

  def before_destroy
    raise HasRoleError unless roles.empty?
  end

end
