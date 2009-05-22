class RoleType < ActiveRecord::Base
  validates_presence_of :title
  has_many :roles

  enumerates do |e|
    e.value :name => 'actor', :title => 'Actor'
    e.value :name => 'director', :title => 'Director'
  end

  def self.its_name(role)
    role.kind_of?(self) ? role.name : valid_name!(role)
  end
end
