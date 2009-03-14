class AwardRequirement < ActiveRecord::Base
  validates_presence_of :award, :required_type
  belongs_to :award

  def validate_awarding(awarding)
    if awarding.send(required_type.pluralize.underscore).empty?
      awarding.errors.add_to_base("requires a recipient of type #{required_type}")
    end
  end
end
