require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "An Awarding for a Movie" do
  before(:each) do
    @movie = Movie.create!(:title => 'Bad Stuff', :release_date => '1999-09-03')
    Awarding.create!(:award => awards(:oscar_best_picture),
                     :movies => [@movie])
  end
  
  it "knows about its award" do
    @movie.should have(1).awardings
    @movie.awardings[0].name.should eql('Academy Award: Best Picture (1999)')
  end
  
  it "deduces its year from the movie's release year" do
    @movie.awardings[0].year.should be(1999)
  end
end

describe "An Awarding for a Person" do
  before(:each) do
    @movie = Movie.create!(:title => 'The Mootix', :release_date => '1999-06-14')
    @actress = Person.create(:firstname => 'Carry', :lastname => 'Most')
    Awarding.create!(:award => awards(:oscar_best_actress),
      :people => [@actress],
      :movies => [@movie])
  end
  
  it "knows about its award" do
    @actress.should have(1).awardings
    @actress.awardings[0].name.should eql('Academy Award: Best Actress (1999)')
  end
  
  it "deduces its year from the movie's release year" do
    @actress.awardings[0].year.should be(1999)
  end
end
