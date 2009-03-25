require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "all persons", :shared => true do
  before(:each) do
    @valid_attributes = {
      :firstname => 'Clint',
      :lastname => 'Eastwood'
    }
  end
end


describe "A Person with a unique name" do
  it_should_behave_like "all persons"
  
  before(:each) do
    @person = Person.create!(@valid_attributes)
  end

  it "is valid given valid attributes" do
    @person.should be_valid
  end
  
  it "can be deleted" do
    @person.destroy
    Person.should have(:no).records
  end
  
  it "has a serial number" do
    @person.serial_number.should == 1
  end
  
  it "does not show its serial number" do
    pending do
      @person.name.should == 'Clint Eastwood'
    end
  end

  it "creates a unique serial number" do
    Person.should_receive(:next_unused_serial_number).twice.and_return(1, 2)
    dupe = Person.create!(@valid_attributes)
  end
end


describe "A Person with a duplicate name" do
  it_should_behave_like "all persons"
  
  before(:each) do
    @person = Person.create!(@valid_attributes)
    @dupe = Person.create!(@valid_attributes)
  end

  it "has a new serial number" do
    @dupe.serial_number.should == 2
  end

  it "shows its serial number" do
    @dupe.name.should == 'Clint Eastwood (2)'
  end
end


describe "an actor", :shared => true do
  before(:each) do
    @actor = Person.create!(:firstname => 'Clint', :lastname => 'Hehaa')
    @movie = Movie.create!(:title => 'Bad and Ugly', :release_date => '2004-12-05')
    @movie.participants.add_actor(@actor)
    @movie.save!
  end
end


describe "A Person with only an actor role in a single 2004 movie" do
  it_should_behave_like "an actor"
  
  it "acts in the movie" do
    @actor.movies.as_actor.should include(@movie)
  end
  
  it "does not direct the movie" do
    @actor.movies.as_director.should == []
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

describe "An actor with coworkers" do
  it_should_behave_like "an actor"
  
  before(:each) do
    @coactor1 = Person.create(:firstname => 'Eddie', :lastname => 'Act')
    @movie.participants.add_actor(@coactor1)
    @director = Person.create(:firstname => 'Zeno', :lastname => 'Direct')
    @movie.participants.add_director(@director)
    @movie.save!
    
    @movie2 = Movie.create!(:title => 'Bad and Ugly, the sequel', :release_date => '2005-12-09')
    @movie2.participants.add_actor(@actor)
    @coactor2 = Person.create(:firstname => 'Duane', :lastname => 'Act')
    @movie2.participants.add_actor(@coactor2)
    @movie2.participants.add_director(@coactor2)
    @movie2.save!

    unrelated_movie = Movie.create!(:title => 'Bad and Ugly, once more', :release_date => '2007-03-12')
    actor_director = Person.create(:firstname => 'Bruno', :lastname => 'DirAct')
    unrelated_movie.participants.add_actor(actor_director)
    unrelated_movie.participants.add_director(actor_director)
    unrelated_movie.save!
  end
  
  it "knows their coworkers from all movies" do
    coworkers = @actor.coworkers
    coworkers.size.should == 3
    coworkers.should include(@coactor1)
    coworkers.should include(@coactor2)
    coworkers.should include(@director)
  end

  it "knows their coworkers from a specific movie" do
    coworkers = @actor.coworkers(:movie => @movie)
    coworkers.size.should == 2
    coworkers.should include(@coactor1)
    coworkers.should include(@director)
  end

  it "knows all their co-actors" do
    coactors = @actor.coworkers.actors
    coactors.size.should == 2
    coactors.should include(@coactor1)
    coactors.should include(@coactor2)
  end

  it "knows their co-actors from a specific movie" do
    coactors = @actor.coworkers(:movie => @movie).actors
    coactors.should == [@coactor1]
  end

  it "knows their directors" do
    directors = @actor.coworkers.directors
    directors.size.should == 2
    directors.should include(@director)
    directors.should include(@coactor2)
  end

  it "knows their director from a specific movie" do
    @actor.coworkers.directors(:movie => @movie).should == [@director]
  end
end
