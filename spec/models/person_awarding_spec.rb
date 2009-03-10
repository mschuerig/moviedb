require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PersonAwarding do
  before(:each) do
    @movie = Movie.create!(:title => 'The Mootix', :release_date => '1999-06-14')
    @actress = Person.create(:firstname => 'Carry', :lastname => 'Most')
    @actress.awardings.create!(:person_award => person_awards(:oscar_best_actress),
                               :movie => @movie)
  end
  
  it "knows about its award" do
    @actress.should have(1).awardings
    @actress.awardings[0].name.should eql('Academy Award: Best Actress (1999)')
  end
  
  it "deduces its year from the movie's release year" do
    @actress.awardings[0].year.should be(1999)
  end
end
