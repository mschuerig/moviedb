class Person < ActiveRecord::Base
  concerned_with :awards, :marriages, :name, :roles, :social

  default_scope :order => 'lastname, firstname, serial_number'

  def self.find(*args)
    args = args.dup
    options = args.extract_options!.dup
    if options[:order] =~ /\bname\b( (?:ASC|DESC))?/i
      options[:order] = "lastname#{$1},firstname#{$1},serial_number#{$1}"
    end
#    unless options[:group] || options[:select]
#      options[:select] = 'people.*, (SELECT COUNT(*) FROM people AS dupe WHERE dupe.lastname = people.lastname AND dupe.firstname = people.firstname) as duplicate_count'
#    end
    args << options
    super(*args)
  end

  def before_destroy
    raise HasRoleError unless roles.empty?
  end

end
