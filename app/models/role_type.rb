class RoleType < ActiveRecord::Base
  validates_presence_of :title
  
  has_many :roles

### TODO
###  create :id => 1, :name => 'actor', :title => 'Actor'
###  create :id => 2, :name => 'director', :title => 'Director'
  
  def self.[](name)
    find_by_name!(name.to_s)
  end
  
  def self.each_name
    ### FIXME
#    self.all.each do |role_type|
    ['actor', 'director'].each do |role_type|
#      yield role_type.name
      yield role_type
    end
  end

  def self.ensure_valid!(name, options = { })
    name = ActiveSupport::Inflector.singularize(name) if options[:singularize]
    ok =
      if options[:clean]
        name = clean_name(name)
        names.include?(name)
      else
        names.include?(name)
      end
    raise ArgumentError, "Not a valid name for a RoleType: #{name.inspect}" unless ok
    name
  end
  
  private
  
  def self.clean_name(name)
    ActiveSupport::Inflector.transliterate(name).gsub(' ', '_').gsub(/[^[:alnum:]_]/, '').underscore.to_s
  end
end
