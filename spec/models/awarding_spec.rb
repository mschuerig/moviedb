require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "all awardings", :shared => true do

  it "can only be given once per year" do
    other_movie = Movie.make(:release_date => @movie.release_date)
    dupe = Awarding.create(:award => @award,
      :movies => [other_movie],
      :people => [@actress].compact)
    dupe.errors.on_base.should include('The award can only be given once per year.')
  end
end

describe "An Awarding for a Movie" do
  it_should_behave_like "all awardings"
  
  before(:each) do
    @movie = Movie.make
    @award = awards(:oscar_best_picture)
    Awarding.create!(:award => @award,
                     :movies => [@movie])
### FIXME
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

describe "An Awarding for a Person" do
  it_should_behave_like "all awardings"

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
  
  it "deduces its year from the movie's release year" do
    @actress.awardings[0].year.should be(@movie.release_year)
  end
end
