require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "An Awarding Validator for an actor" do
  before do
    award = stub_model(Award)
    @validator = AwardingValidator.new([
      :association => 'people',
      :role        => 'actor',
      :count       => 1
    ])
    @awarding = Awarding.new(:award => award, :year => 2004)
  end

  it "adds an error to an awarding that does not have an associated person" do
    @validator.validate_awarding(@awarding)
    @awarding.errors.on_base.should_not be_nil
    @awarding.errors.on_base.should include('requires a actor recipient')
  end

  it "adds an error to an awarding that only has a director" do
    movie = Movie.make
    director = Person.make
    movie.participants.add_director(director)
    movie.save!
    @awarding.people << director
    @validator.validate_awarding(@awarding)
    @awarding.errors.on_base.should_not be_nil
    @awarding.errors.on_base.should include('requires a actor recipient')
  end

end
