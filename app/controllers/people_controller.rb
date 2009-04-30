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
      format.json do
        @people = Person.all(:offset => @offset_limit[0], :limit => @offset_limit[1])
        @count = Person.count
        render
      end
    end
  end

  # GET /people/1
  # GET /people/1.json
  def show
    @person = @scope.find(params[:id])

    respond_to do |format|
      format.json
    end
  end

  
  # POST /people
  # POST /people.json
  def create
    @person = @scope.new(params[:attributes])

    respond_to do |format|
      if @person.save
        format.json { render :action => :show, :location => person_path(@person) }
      else
        ### TODO
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.json
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
  # DELETE /people/1.json
  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) } ### TODO
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
