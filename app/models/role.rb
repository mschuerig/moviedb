class Role < ActiveRecord::Base
  belongs_to :person
  belongs_to :role_type
  belongs_to :movie
  validates_presence_of :person_id, :role_type_id, :movie_id
  
  RoleType.each_name do |name, clean_name|
    named_scope "#{clean_name}_roles",
      :joins => :role_type,
      :conditions => { :role_types => { :name => name }}
  end
end
