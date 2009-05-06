class MoviesController < ApplicationController
  include LazyJason
  include QueryScope
  before_filter :load_scope
  
  query_scope :resource => :movie_item, :only => :index do
    allow     :title, :release_year, :release_date, :award_count
    rename    :year => :release_year
    rename    :date => :release_date
    rename    [:awards, :award_count, 'award-count'] => :award_count
  end
  
  def summary
    @movie = scope.find(params[:id])
    respond_to do |format|
      format.json do
        render :template => 'movies/summary'
      end
    end
  end
  
  private
  
  def scope
    @scope
  end
  
  def set_object(value)
    @movie = value
  end
  
  def set_object_list(values)
    @movies = values
  end
  
  def set_count(count)
    @count = count
  end
  
  def load_scope
    @scope = Movie
  end
end
