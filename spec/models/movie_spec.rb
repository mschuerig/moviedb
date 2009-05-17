require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

shared_examples_for "Any Movie" do
  before do
    @actor = Person.new(:firstname => 'Clint', :lastname => 'Eastwood')
  end

  it "should be valid given valid attributes" do
###    debugger
    @movie.should be_valid
  end

  it "can be saved without an exception" do
    @movie.save!
  end

  it "knows about participants even before saving" do
    @movie.participants.add_actor(@actor)
    pending do
      @movie.participants.should include(@actor)
    end
  end
end


describe "Movie (2002)" do
  it_should_behave_like "Any Movie"

  before do
    @valid_attributes = {
      :title => 'Running Down the Rails',
      :release_date => '2002-11-29'
    }
    @movie = Movie.create(@valid_attributes)
  end

  it "computes its release year" do
    @movie.release_year.should == 2002
  end

  it "is found for 2002" do
    Movie.in_year(2002).should include(@movie)
  end

  it "is not found for 2003" do
    Movie.in_year(2003).should_not include(@movie)
  end

  describe "with only an actor" do
    before do
      @actor.save!
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

  describe "with two actors" do
    before do
      @actor.save!
      @movie.participants.add_actor(@actor)
      @actor2 = Person.create!(:firstname => 'Bruno', :lastname => 'Rathaby')
      @movie.participants.add_actor(@actor2)
      @movie.save!
      @cand_actor = Person.create!(:firstname => 'Notyet', :lastname => 'Wai-Ting')
    end

    it "can have actors replaced" do
      others = [@actor.to_param, @cand_actor.to_param]
      @movie.participants.replace_actors(others)
#      pending do
#        movie_should_have_new_actors
#      end
      @movie.save!
      movie_should_have_new_actors
    end

    def movie_should_have_new_actors
      @movie.participants.as_actor.size.should == 2
      @movie.participants.as_actor.should include(@actor)
      @movie.participants.as_actor.should include(@cand_actor)
    end
  end
end

describe "Unsaved Movie" do
  it_should_behave_like "Any Movie"

  before do
    @valid_attributes = {
      :title => 'Running Down the Rails',
      :release_date => '2002-11-29'
    }
    @movie = Movie.new(@valid_attributes)
  end

  describe "with an existing actor" do
    it_should_behave_like "Any Movie"

    before do
      @actor.save!
      @movie.participants.add_actor(@actor)
    end
  end

  describe "with a new actor" do
    it_should_behave_like "Any Movie"

    before do
      @movie.participants.add_actor(@actor)
    end
  end

end
