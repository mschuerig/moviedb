class Role < ActiveRecord::Base
  validates_presence_of :person_id, :role_type_id, :movie_id, :credited_as
  validates_uniqueness_of :role_type_id, :scope => [:person_id, :movie_id]

  belongs_to :person
  belongs_to :role_type
  belongs_to :movie
  
  RoleType.each_name do |name, clean_name|
    named_scope "#{clean_name}_roles",
      :joins => :role_type,
      :conditions => { :role_types => { :name => name }}
  end
  
  def before_validation
    if self.credited_as.blank?
      self.credited_as = "#{person.firstname} #{person.lastname}"
    end
  end
  
end
