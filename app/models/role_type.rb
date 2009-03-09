class RoleType < ActiveRecord::Base
  validates_presence_of :name
  
  def self.each_name
#    RoleType.each do |rt|
    ['Actor', 'Director'].each do |name|
      ### TODO extract
      clean_name = ActiveSupport::Inflector.transliterate(name).gsub(' ', '_').gsub(/[^[:alnum:]_]/, '').underscore
      yield name, clean_name
    end
  end
end
