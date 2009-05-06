require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "An Awarding" do
  before do
    @movie = Movie.make
    @actress = Person.make
    @movie.participants.add_actor(@actress)
    @movie.save!
    @award = awards(:oscar_best_actress)
    @awarding = Awarding.create!(:award => @award,
      :people => [@actress],
      :movies => [@movie])
  end

  it "can only be given once per year" do
    other_movie = Movie.make(:release_date => @movie.release_date)
    other_movie.participants.add_actor(@actress)
    other_movie.save!
    dupe = Awarding.create(:award => @award,
      :movies => [other_movie],
      :people => [@actress].compact)
    dupe.errors.on_base.should include('The award can only be given once per year.')
  end

  it "is deleted when the movie is deleted" do
    @movie.destroy
    lambda { @awarding.reload }.should raise_error(ActiveRecord::RecordNotFound)
  end

  it "is deleted when the actress is deleted" do
    pending do
      ### TODO the actress can't be deleted as she's still participant of a movie
      @actress.destroy
      lambda { @awarding.reload }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

describe "An Awarding for an actor in a movie" do
  before do
    @movie = Movie.make
    @award = awards(:oscar_best_actor)
  end

  it "can be given to an actor in the movie" do
    actor = Person.make
    @movie.participants.add_actor(actor)
    @movie.save!
    @awarding = Awarding.create!(:award => @award,
      :people => [actor],
      :movies => [@movie])
  end

  it "cannot be given to the director of the movie" do
    director = Person.make
    @movie.participants.add_director(director)
    @movie.save!
    @awarding = Awarding.new(:award => @award,
      :people => [director],
      :movies => [@movie])
    @awarding.should_not be_valid
  end

  it "cannot be given to a person who did not participate in the movie" do
    outsider = Person.make
    @movie.save!
    @awarding = Awarding.new(:award => @award,
      :people => [outsider],
      :movies => [@movie])
    @awarding.should_not be_valid
  end
end



describe "An awarded movie" do
  before do
    @movie = Movie.make
    @award = awards(:oscar_best_picture)
    Awarding.create!(:award => @award,
                     :movies => [@movie])
### TODO create awardings through association
#    @movie.awardings.create!(:award => awards(:oscar_best_picture))
  end

  it "knows about its award" do
    @movie.should have(1).awardings
    @movie.awardings[0].name.should == "Academy Award: Best Picture (#{@movie.release_year})"
  end

  it "deduces its year from the movie's release year" do
    @movie.awardings[0].year.should == @movie.release_year
  end
end

describe "An awarded person" do
  before do
    @movie = Movie.make
    @actress = Person.make
    @movie.participants.add_actor(@actress)
    @movie.save!
    @award = awards(:oscar_best_actress)
    Awarding.create!(:award => @award,
      :people => [@actress],
      :movies => [@movie])
  end

  it "knows about its award" do
    @actress.should have(1).awardings
    @actress.awardings[0].name.should == "Academy Award: Best Actress in a Leading Role (#{@movie.release_year})"
  end

  it "deduces the year of their award from the movie's release year" do
    @actress.awardings[0].year.should == @movie.release_year
  end
end
