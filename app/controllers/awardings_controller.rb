class AwardingsController < ApplicationController
  include QueryScope
  before_filter :load_scope

  query_scope do
    allow :year
  end

  def index
    respond_to do |format|
      format.json do
        @awardings = @scope.all(:include => [:movies, :people, :award])
        set_content_range(@awardings.size)
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
