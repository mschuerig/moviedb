class MoviesController < ApplicationController
  include QueryScope
  
  query_scope :resource => :movie_item, :only => :index do
    allow     :title, :year, :release_date, :awards, :awardings
    condition :year      => "release_year :op ?"
    order     :year      => "release_date :dir"
    condition :awardings => "award_count :op ?"
    order     :awardings => "award_count :dir"
  end
  
  # GET /movies
  # GET /movies.json
  def index
    respond_to do |format|
      format.html { render :layout => false }
      format.json do
        @movies = MovieItem.all(:include => { :awardings => :award },
          :offset => @offset_limit[0], :limit => @offset_limit[1])
        @count = MovieItem.count
        render
      end
    end
  end

  def summary
    @movie = Movie.find(params[:id])
    respond_to do |format|
      format.json do
        render :template => 'movies/summary'
      end
    end
  end
  
  # GET /movies/1
  # GET /movies/1.json
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.json
    end
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(params[:attributes])

    respond_to do |format|
      if @movie.save
        format.json { render :action => :show, :location => movie_path(@movie) }
      else
        ### TODO
      end
    end
  end

  # PUT /movies/1
  # PUT /movies/1.json
  def update
    @movie = Movie.find(params[:id])
    respond_to do |format|
      if @movie.update_attributes(params[:attributes])
        format.json { render :action => :show }
      else
        ### TODO error response
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) } ### TODO
    end
  end
end
