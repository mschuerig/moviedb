require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Role do

  before(:each) do
    @actor = Person.create!(:firstname => 'Clint', :lastname => 'Hehaa')
    @movie = Movie.create!(:title => 'Bad and Ugly')
  end
  
  it "creates a default credit name based on person name" do
    role = @movie.add_actor(@actor)
    @movie.save!
    role.credited_as.should eql('Clint Hehaa')
  end
  
  it "uses a given credit name" do
    role = @movie.add_actor(@actor, :as => 'Clint H.')
    @movie.save!
    role.credited_as.should eql('Clint H.')
  end
  
end

