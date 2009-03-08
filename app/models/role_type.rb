class RoleType < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def self.each_name
#    RoleType.each do |rt|
    ['Actor', 'Director'].each do |name|
      clean_name = name.underscore.gsub(' ', '_') ### FIXME extract and make really safe
      yield name, clean_name
    end
  end
end
