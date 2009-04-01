require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "An Award Requirement for an actor" do
  before(:each) do
    award = stub_model(Award)
    @req = AwardRequirement.create!(
      :award => award,
      :association => 'people',
      :role_type_id => RoleType[:actor],
      :count => 1
    )
    @awarding = Awarding.new(:award => award, :year => 2004)
  end

  it "adds an error to an awarding that does not have an associated person" do
    @req.validate_awarding(@awarding)
    @awarding.errors.on_base.should_not be_nil
    @awarding.errors.on_base.should include('requires a Actor recipient')
  end

  it "adds an error to an awarding that only has a director" do
    movie = Movie.make
    director = Person.make
    movie.participants.add_director(director)
    movie.save!
    @awarding.people << director
    @req.validate_awarding(@awarding)
    @awarding.errors.on_base.should_not be_nil
    @awarding.errors.on_base.should include('requires a Actor recipient')
  end

end
