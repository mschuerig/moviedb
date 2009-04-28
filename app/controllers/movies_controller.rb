class MoviesController < ApplicationController
  include QueryScope
  
  query_scope :resource => :movie_item, :only => :index do
    allow     :title, :release_date, :awardings
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
      format.html { render :text => @movie.summary, :layout => false }
      format.json do
        render :template => 'movies/summary'
      end
    end
  end
  
  # GET /movies/1
  # GET /movies/1.xml
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
      format.xml  { render :xml => @movie }
    end
  end

  # GET /movies/new
  # GET /movies/new.xml
  def new
    @movie = Movie.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @movie }
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
  end

  # POST /movies
  # POST /movies.xml
  def create
    @movie = Movie.new(params[:movie])

    respond_to do |format|
      if @movie.save
        flash[:notice] = 'Movie was successfully created.'
        format.html { redirect_to(@movie) }
        format.xml  { render :xml => @movie, :status => :created, :location => @movie }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /movies/1
  # PUT /movies/1.xml
  def update
    @movie = Movie.find(params[:id])
    respond_to do |format|
      if @movie.update_attributes(params[:attributes])
        format.json { render :action => :show }
      else
        ### TODO error response
      end
    end
=begin
    respond_to do |format|
      if @movie.update_attributes(params[:movie])
        flash[:notice] = 'Movie was successfully updated.'
        format.html { redirect_to(@movie) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
=end
  end

  # DELETE /movies/1
  # DELETE /movies/1.xml
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to(movies_url) }
      format.xml  { head :ok }
    end
  end
end
