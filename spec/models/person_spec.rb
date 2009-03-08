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
    @movie = Movie.create!(:title => 'Bad and Ugly', :release_date => '2004-12-05')
    @movie.add_actor(@actor)
    @movie.save!
  end
  
  it "acts in the movie" do
    @actor.movies.as_actor.should include(@movie)
  end
  
  it "does not direct the movie" do
    @actor.movies.as_director.should be_empty
  end
  
  it "cannot be deleted" do
    lambda { @actor.destroy }.should raise_error(Person::HasRoleError)
  end
  
  it "is found as an actor" do
    Person.actors.should include(@actor)
  end

  it "is found as an actor with a movie in 2004" do
    Person.actors.with_movie_in_year(2004).should include(@actor)
  end

  it "is not found as an actor with a movie in 2005" do
    Person.actors.with_movie_in_year(2005).should_not include(@actor)
  end

  it "is not found as a director" do
    Person.directors.should_not include(@actor)
  end
end
