require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "An Awarding for a Movie" do
  before(:each) do
    @movie = Movie.make
#    Awarding.create!(:award => awards(:oscar_best_picture),
#                     :movies => [@movie])
    @movie.awardings.create!(:award => awards(:oscar_best_picture))
  end

  it "knows about its award" do
    @movie.should have(1).awardings
    @movie.awardings[0].name.should == "Academy Award: Best Picture (#{@movie.release_year})"
  end
  
  it "deduces its year from the movie's release year" do
    @movie.awardings[0].year.should be(@movie.release_year)
  end
end

describe "An Awarding for a Person" do
  before(:each) do
    @movie = Movie.make
    @actress = Person.make
    Awarding.create!(:award => awards(:oscar_best_actress),
      :people => [@actress],
      :movies => [@movie])
  end
  
  it "knows about its award" do
    @actress.should have(1).awardings
    @actress.awardings[0].name.should == "Academy Award: Best Actress (#{@movie.release_year})"
  end
  
  it "deduces its year from the movie's release year" do
    @actress.awardings[0].year.should be(@movie.release_year)
  end
end
