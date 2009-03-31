class AwardRequirement < ActiveRecord::Base
  validates_presence_of :award, :required_type
  belongs_to :award

  ### TODO clean up or simply merge into Award
  
  def validate_awarding(awarding)
    if awarding.send(required_type.pluralize.underscore).empty?
      awarding.errors.add_to_base("requires a recipient of type #{required_type}")
    end
  end
  
  def association_count
    [required_type.pluralize.underscore.to_sym, 1]
  end
end
