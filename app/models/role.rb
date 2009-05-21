class Role < ActiveRecord::Base
  belongs_to :person
  belongs_to :role_type
  belongs_to :movie
  has_and_belongs_to_many :characters ### TODO only valid for role_type 'actor' -- subclass?

  attr_readonly :person, :role_type, :movie

  RoleType.each_name do |name|
    named_scope "#{name}_roles",
      :joins => :role_type,
      :conditions => { :role_types => { :name => name } }
  end

  def before_validation
    if self.credited_as.blank? && person
      self.credited_as = person.credits_name
    end
  end

end
