require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Person do
  fixtures :role_types

  before(:each) do
    @valid_attributes = {
      :firstname => 'Clint',
      :lastname => 'Eastwood'
    }
  end

  it "should create a new instance given valid attributes" do
    Person.create!(@valid_attributes)
  end
end

describe "Person with actor role in a single movie" do
  fixtures :role_types

  before(:each) do
    @person = Person.create!(:firstname => 'Clint', :lastname => 'Eastwood')
    @movie = Movie.create!(:title => 'Bad Stuff')
    @movie.add_actor(@person)
    @movie.save!
  end

  it "acts in the movie" do
    @person.actor_of.should include(@movie)
  end
  
  it "is among the actors of the movie" do
    @movie.actors.should include(@person)
  end
  
  it "does not direct the movie" do
    @person.director_of.should be_empty
  end
  
  it "cannot be deleted" do
    lambda { @person.destroy }.should raise_error(Person::HasRoleError)
  end
  
  it "is found as an actor" do
    Person.actors.should include(@person)
  end

  it "is not found as a director" do
    Person.directors.should_not include(@person)
  end
end
