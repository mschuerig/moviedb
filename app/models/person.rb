class Person < ActiveRecord::Base
  class HasRoleError < StandardError; end

  validates_presence_of :firstname, :lastname

  has_many :roles, :include => :role_type
  
  module RoleTypeExtensions
    RoleType.each_name do |name, clean_name|
      define_method("as_#{clean_name}") do
        self.scoped(
          :joins => 'JOIN role_types ON roles.role_type_id = role_types.id',
          :conditions => { :role_types => { :name => name }})
      end
    end
  end
  
  has_many :movies, :through => :roles, :extend => RoleTypeExtensions, :order => 'release_date'
  
  default_scope :order => 'lastname, firstname'
  
  RoleType.each_name do |name, clean_name|
    named_scope clean_name.pluralize,
      :joins => { :roles => :role_type },
      :conditions => { :roles => { :role_types => { :name => name }}}
  end
  
  named_scope :with_movie_in_year, lambda { |year|
    { 
      :joins => { :roles => :movie },
      :conditions => Movie.in_year_condition(year)
    }
  }
  
  def before_destroy
    raise HasRoleError unless roles.empty?
  end
end
