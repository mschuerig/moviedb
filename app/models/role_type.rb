class RoleType < ActiveRecord::Base
  validates_presence_of :title
  has_many :roles
  
  enumerates do |e|
    e.value :name => 'actor', :title => 'Actor'
    e.value :name => 'director', :title => 'Director'
  end
  
  class << self

    def ensure_valid!(name, options = { })
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
  
    def clean_name(name)
      ActiveSupport::Inflector.transliterate(name).gsub(' ', '_').gsub(/[^[:alnum:]_]/, '').underscore.to_s
    end
  end
end
