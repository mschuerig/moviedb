class Role < ActiveRecord::Base
  validates_presence_of :person, :role_type, :movie, :credited_as

  belongs_to :person
  belongs_to :role_type
  belongs_to :movie
  
  attr_readonly :person, :role_type, :movie
  
  RoleType.each_name do |name|
    named_scope "#{name}_roles",
      :joins => :role_type,
      :conditions => { :role_types => { :name => name } }
  end
  
  def before_validation
    if self.credited_as.blank?
      self.credited_as = person.credits_name
    end
  end
  
end
