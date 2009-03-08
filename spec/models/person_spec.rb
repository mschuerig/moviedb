require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Person do

  before(:each) do
    @valid_attributes = {
      :firstname => 'Clint',
      :lastname => 'Eastwood'
    }
    @person = Person.create(@valid_attributes)
  end

  it "is valid given valid attributes" do
    @person.should be_valid
  end
  
  it "can be deleted" do
    @person.destroy
    Person.should have(:no).records
  end
end

describe "Person with actor role in a single movie" do

  before(:each) do
    @actor = Person.create!(:firstname => 'Clint', :lastname => 'Hehaa')
    @movie = Movie.create!(:title => 'Bad and Ugly')
    @movie.add_actor(@actor)
    @movie.save!
  end
  
  it "acts in the movie" do
    @actor.actor_of.should include(@movie)
  end
  
  it "does not direct the movie" do
    @actor.director_of.should be_empty
  end
  
  it "cannot be deleted" do
    lambda { @actor.destroy }.should raise_error(Person::HasRoleError)
  end
  
  it "is found as an actor" do
    Person.actors.should include(@actor)
  end

  it "is not found as a director" do
    Person.directors.should_not include(@actor)
  end
end
