class PeopleController < ApplicationController
  include LazyJason
  include QueryScope
  before_filter :load_scope
  before_filter :map_attributes, :only => [ :create, :update ]
  
  query_scope :only => :index do
    allow     :name, :firstname, :lastname, :date_of_birth
    rename    [:dob, :date_of_birth, 'date-of-birth', :birthday] => :date_of_birth
    rename    [:first_name, 'first-name'] => :firstname
    rename    [:last_name, 'last-name']  => :lastname
    condition :name => "LOWER(firstname || ' ' || lastname) :op LOWER(?)"
    order     :name => "lastname :dir, firstname :dir, serial_number :dir"
  end
  
  
  private
  
  def scope
    @scope
  end
  
  def set_object(value)
    @person = value
  end
  
  def set_object_list(values)
    @people = values
  end
  
  def set_count(count)
    @count = count
  end
  
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
