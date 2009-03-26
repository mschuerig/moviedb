class MoviesController < ApplicationController
  
  def parse_range_header(range = nil)
    range ||= request.headers['Range']
    if range && range =~ /items=(.*)-(.*)/
      first_item, last_item = $1.to_i, $2.to_i
      offset = first_item
      limit = last_item > 0 ? last_item - offset + 1 : nil
      { :offset => offset, :limit => limit }
    else
      {}
    end
  end
  
  def parse_order_params
    ### TODO use request.query_string
    order_clause = params.keys.grep(%r{^(/|\\)}).map do |attr|
      o = attr[1..-1]
      if attr[0..0] == '\\'
        o << ' DESC'
      end
      o
    end
    order_clause.empty? ? nil : order_clause.join(',')
  end
  
  # GET /movies
  # GET /movies.xml
  def index
    respond_to do |format|
      format.html { render :layout => false }
      format.json do
        @range = parse_range_header
        @movies = Movie.find(:all,
                             :include => { :awardings => :award },
                             :offset => @range[:offset],
                             :limit => @range[:limit],
                             :order => parse_order_params)
        @count = Movie.count
        render :template => 'movies/index.json.rb'
      end
      format.xml  { render :xml => @movies }
    end
  end

  # GET /movies/1
  # GET /movies/1.xml
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @movie }
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
      if @movie.update_attributes(params[:movie])
        flash[:notice] = 'Movie was successfully updated.'
        format.html { redirect_to(@movie) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
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
