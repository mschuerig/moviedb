
class AwardingValidator
  
  def initialize(requirements)
    @requirements = Array(requirements).map { |req|
      Requirement.new(req[:association], req[:count], req[:role])
    }
  end
  
  def validate_awarding(awarding)
    @requirements.each { |req| req.check(awarding) }
  end
  
  private
  
  class Requirement
    def initialize(association, count, role = nil)
      @association, @count, @role = association, count, role
    end
    
    def check(awarding)
      awardees = awarding.send(@association)
      if @role
        roles = awarding.movies.inject([]) { |roles, movie|
          roles += movie.participants.as(@role)
        }
        awardees = awardees.select { |a| roles.include?(a) }
      end
  
      if awardees.size < @count
        what = @role || @association
        if @count > 1
          awarding.errors.add_to_base("requires #{@count} #{what} recipients.")
        else
          awarding.errors.add_to_base("requires a #{what} recipient.")
        end
      end
    end
  end
end
