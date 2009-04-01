require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "An Awarding" do
  before(:each) do
    @movie = Movie.make
    @actress = Person.make
    @award = awards(:oscar_best_actress)
    @awarding = Awarding.create!(:award => @award,
      :people => [@actress],
      :movies => [@movie])
  end

  it "can only be given once per year" do
    other_movie = Movie.make(:release_date => @movie.release_date)
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
    @actress.destroy
    lambda { @awarding.reload }.should raise_error(ActiveRecord::RecordNotFound)
  end  
end

describe "An Awarding for an actor in a movie" do
  it "can be given to an actor in the movie"do
    pending
  end

  it "cannot be given to the director of the movie"do
    pending
  end

  it "cannot be given to a person who did not participate in the movie"do
    pending
  end
end



describe "An awarded movie" do
  before(:each) do
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
  before(:each) do
    @movie = Movie.make
    @actress = Person.make
    @award = awards(:oscar_best_actress)
    Awarding.create!(:award => @award,
      :people => [@actress],
      :movies => [@movie])
  end
  
  it "knows about its award" do
    @actress.should have(1).awardings
    @actress.awardings[0].name.should == "Academy Award: Best Actress (#{@movie.release_year})"
  end
  
  it "deduces the year of their award from the movie's release year" do
    @actress.awardings[0].year.should == @movie.release_year
  end
end
