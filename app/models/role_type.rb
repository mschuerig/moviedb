class RoleType < ActiveRecord::Base
  validates_presence_of :name
  
  def self.names
#    RoleType.each do |rt|
    ### FIXME
    ['Actor', 'Director']
  end

  def self.each_name
    names.zip(clean_names).each do |name, clean|
      yield name, clean
    end
  end

  def self.ensure_valid!(name, options = { })
    name = ActiveSupport::Inflector.singularize(name) if options[:singularize]
    ok =
      if options[:clean]
        name = clean_name(name)
        clean_names.include?(name)
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
  
  def self.clean_names
    @clean_names ||= names.map { |n| clean_name(n) }
  end
end
