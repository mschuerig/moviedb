class AwardingsController < ApplicationController
  before_filter :load_scope

  def index
    respond_to do |format|
      format.json do
        @awardings = @scope.all(:include => [:movies, :people, :award])
        @count = @awardings.size
        response.headers['Content-Range'] = "items 0-#{@count - 1}/#{@count}" ### FIXME
        render
      end
    end
  end
  
  private
    
  def load_scope
    @scope = Awarding
    if award_id = params[:award_id]
      @scope = @scope.for_award(award_id)
    end
  end
end
