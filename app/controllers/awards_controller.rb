class AwardsController < ApplicationController
  # GET /awards
  # GET /awards.json
  def index
    respond_to do |format|
      format.json do
        @award_groups = Award.top_level.all(:include => :children)
        render
      end
    end
  end
end
