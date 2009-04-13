class WelcomeController < ApplicationController
  def index
    respond_to do |format|
      format.html { redirect_to movies_url }
    end
  end

end
