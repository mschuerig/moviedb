require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "all persons", :shared => true do
  before(:each) do
    @valid_attributes = {
      :firstname => 'Clint',
      :lastname => 'Eastwood'
    }
  end
end


describe Person do
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
    @person.serial_number.should eql(1)
  end
  
  it "does not show its serial number" do
    pending do
      @person.name.should eql('Clint Eastwood')
    end
  end

  it "creates a unique serial number" do
    Person.should_receive(:next_unused_serial_number).twice.and_return(1, 2)
    dupe = Person.create!(@valid_attributes)
  end
end


describe "Person with a duplicate name" do
  it_should_behave_like "all persons"
  
  before(:each) do
    @person = Person.create!(@valid_attributes)
    @dupe = Person.create!(@valid_attributes)
  end

  it "has a new serial number" do
    @dupe.serial_number.should eql(2)
  end

  it "shows its serial number" do
    @dupe.name.should eql('Clint Eastwood (2)')
  end
end


describe "Person with only an actor role in a single 2004 movie" do
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
