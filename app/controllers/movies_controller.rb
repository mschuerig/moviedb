class MoviesController < ApplicationController
  include LazyJason
  include QueryScope
  before_filter :load_scope
  normalize_references :actors, :directors, :awardings

  query_scope :only => :index do
    allow     :title, :release_year, :release_date, :awardings_count
    rename    :year => :release_year
    rename    :date => :release_date
    rename    [:awardings, :awards, :award_count, 'award-count'] => :awardings_count
  end

  private

  def scope
    @scope.scoped(:include => { :awardings => :award })
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
