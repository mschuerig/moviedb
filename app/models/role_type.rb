class RoleType < ActiveRecord::Base
  enumerate_by :name
  validates_presence_of :title
  has_many :roles

  bootstrap(
    { :id => 1, :name => 'actor',    :title => 'Actor' },
    { :id => 2, :name => 'director', :title => 'Director' }
  )

  def self.its_name(role)
    role.kind_of?(self) ? role.name : valid_name!(role)
  end
  
  class << self
    def each_name(&block)
      all.map(&:name).each(&block)
    end
  
    def valid_name!(name, options = {})
      name = name.to_s
      name = ActiveSupport::Inflector.singularize(name) if options[:singularize]
      name = clean_name(name) if options[:clean]
      names = all.map(&:name)
      unless names.include?(name)
        raise ArgumentError, "Not a valid name for a #{self.name}: #{name.inspect}"
      end
      name
    end
  
    private
  
    def clean_name(name)
      ActiveSupport::Inflector.transliterate(name).gsub(' ', '_').gsub(/[^[:alnum:]_]/, '').underscore.to_s
    end
  end
end
