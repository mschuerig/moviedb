require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MovieAwarding do
  before(:each) do
    @movie = Movie.create!(:title => 'Bad Stuff', :release_date => '1999-09-03')
    @movie.awardings.create!(:movie_award => movie_awards(:oscar_best_picture))
  end
  
  it "knows about its award" do
    @movie.should have(1).awardings
    @movie.awardings[0].name.should eql('Academy Award: Best Picture (1999)')
  end
  
  it "deduces its year from the movie's release year" do
    @movie.awardings[0].year.should be(1999)
  end
end
