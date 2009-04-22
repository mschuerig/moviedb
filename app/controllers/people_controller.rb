class PeopleController < ApplicationController
  include QueryScope
  before_filter :load_scope, :only => [:show, :edit, :create]
  before_filter :map_attributes, :only => [ :create, :update ]
  
  query_scope :only => :index do
    allow     :name
    condition :name => "LOWER(firstname || ' ' || lastname) :op LOWER(?)"
    order     :name => "lastname :dir, firstname :dir, serial_number :dir"
  end
  
  # GET /people
  # GET /people.json
  def index
    respond_to do |format|
      format.html { render :layout => false }
      format.json do
        @people = Person.all(:offset => @offset_limit[0], :limit => @offset_limit[1])
        @count = Person.count
        render
      end
    end
  end

  # GET /people/1
  # GET /people/1.xml
  def show
    @person = @scope.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @person = Person.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = @scope.find(params[:id])
  end

  # POST /people
  # POST /people.xml
  def create
    @person = @scope.new(params[:person])

    respond_to do |format|
      if @person.save
        flash[:notice] = 'Person was successfully created.'
        format.html { redirect_to(@person) }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = Person.find(params[:id])

    respond_to do |format|
      if @person.update_attributes(params[:attributes])
        format.json { render :action => :show }
      else
        ### TODO error response
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def load_scope
    @scope = Person
    if movie_id = params[:movie_id]
      @scope = @scope.participating_in_movie(movie_id)
    end
    if kind = params[:kind]
      kind = RoleType.ensure_valid!(kind, :clean => true, :singularize => true)
      @scope = @scope.send(kind.pluralize)
    end
  end
  
  def map_attributes
    if attributes = params[:attributes]
      attributes[:date_of_birth] = attributes.delete(:dob)
    end
  end
end
