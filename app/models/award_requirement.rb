class AwardRequirement < ActiveRecord::Base
  validates_presence_of :award, :association, :count
  validates_numericality_of :count
  belongs_to :award
  belongs_to :role_type

  def validate_awarding(awarding)
    awardees = awarding.send(association)
    if role_type
      roles = awarding.movies.inject([]) { |roles, movie|
        roles += movie.participants.as(role_type)
      }
      awardees = awardees.select { |a| roles.include?(a) }
    end

    if awardees.size < count
      what = role_type ? role_type.title : association
      if count > 1
        awarding.errors.add_to_base("requires #{count} #{what} recipients.")
      else
        awarding.errors.add_to_base("requires a #{what} recipient.")
      end
    end
  end
end
