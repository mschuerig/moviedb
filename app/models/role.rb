class Role < ActiveRecord::Base
  validates_presence_of :person, :role_type, :movie, :credited_as

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
