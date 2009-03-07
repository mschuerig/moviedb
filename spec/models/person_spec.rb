require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Person do
  before(:each) do
    @valid_attributes = {
      :firstname => 'Clint',
      :lastname => 'Eastwood'
    }
  end

  it "should create a new instance given valid attributes" do
    Person.create!(@valid_attributes)
  end
end

describe "Person with role in a movie" do
  before(:each) do
    @person = Person.create!(:firstname => 'Clint', :lastname => 'Eastwood')
    @movie = Movie.create!(:title => 'Bad Stuff')
    @role = MovieRole.create!(:person => @actor, :role => roles(:actor), :movie => @movie)
  end

  it "cannot be delete" do

  end
end
