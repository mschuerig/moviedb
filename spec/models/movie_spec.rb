require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Movie do
  
  before(:each) do
    @valid_attributes = {
      :title => 'Running Down the Rails'
    }
    @movie = Movie.create(@valid_attributes)
  end

  it "should be valid given valid attributes" do
    @movie.should be_valid
  end
end

describe "Movie with roles" do
  before(:each) do
    @movie = Movie.create!(:title => 'Bad Stuff')
    @actor = Person.create!(:firstname => 'Clint', :lastname => 'Eastwood')
    @movie.add_actor(@actor)
    @movie.save!
  end

  it "has an actor" do
    @movie.actors.should include(@actor)
  end
  
  it "does not have a director" do
    @movie.directors.should be_empty
  end
  
  it "deletes related roles when deleted itself" do
    @movie.destroy
    @actor.roles.should be_empty
  end
  
end
