class RoleType < ActiveRecord::Base
  validates_presence_of :title
  
  has_many :roles

  protected
  
  def self.enumerations
    creator = EnumerationCreator.new(self)
    yield creator
    @enum_cache = creator.cache
  end
  
  class EnumerationCreator
    def initialize(model)
      @model = model
    end
    def create(options)
      unless @model.find_by_name(options[:name])
        @model.create!(options)
      end
    end
    def cache
      @model.all.inject({}) do |c, e|
        c[e.name] = e
        c
      end
    end
  end

  public
  
  enumerations do |v|
    v.create :name => 'actor', :title => 'Actor'
    v.create :name => 'director', :title => 'Director'
  end
  
  class << self

    def all
      @all ||= @enum_cache.values
    end
    
    def find_by_name(name)
      @enum_cache[name.to_s]
    end
    alias :[] :find_by_name
    
    def find_by_name!(name)
      find_by_name(name) or raise ActiveRecord::RecordNotFound, "Couldn't find RoleType with name = #{name}"
    end
    
    def each_name
      all.each do |role_type|
#    ['actor', 'director'].each do |role_type|
        yield role_type.name
#      yield role_type
      end
    end

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
