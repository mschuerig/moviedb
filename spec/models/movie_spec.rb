require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Movie (2002)" do
  before(:each) do
    @valid_attributes = {
      :title => 'Running Down the Rails',
      :release_date => '2002-11-29'
    }
    @movie = Movie.create(@valid_attributes)
  end

  it "should be valid given valid attributes" do
    @movie.should be_valid
  end

  it "should compute its release year" do
    @movie.release_year.should == 2002
  end
  
  it "is found for 2002" do
    Movie.in_year(2002).should include(@movie)
  end

  it "is not found for 2003" do
    Movie.in_year(2003).should_not include(@movie)
  end
  
  it "knows about participants even before saving" do
    actor = Person.create!(:firstname => 'Clint', :lastname => 'Eastwood')
    role = @movie.participants.add_actor(actor)
    pending do
      @movie.participants.should include(actor)
    end
  end
end

describe "Movie with only an actor" do
  before(:each) do
    @movie = Movie.create!(:title => 'Bad Stuff')
    @actor = Person.create!(:firstname => 'Clint', :lastname => 'Eastwood')
    @movie.participants.add_actor(@actor)
    @movie.save!
  end

  it "has an actor" do
    @movie.participants.as_actor.should include(@actor)
  end
  
  it "does not have a director" do
    @movie.participants.as_director.should == []
  end
  
  it "deletes related roles when deleted itself" do
    @movie.destroy
    @actor.roles.should be_empty
  end
end
