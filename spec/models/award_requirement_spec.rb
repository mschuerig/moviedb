require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AwardRequirement do
  before(:each) do
    award = stub_model(Award)
    @req = AwardRequirement.create!(
      :award => award,
      :required_type => 'Person'
    )
#    @awarding = stub_model(Awarding) do |awarding|
#      awarding.people = stub_model(Person)
#    end
    actor = Person.create!(:firstname => 'Get', :lastname => 'It')
    @awarding = Awarding.create!(:award => award, :year => 2004, :people => [actor])
  end

  it "adds an error to an awarding if it does not fulfill the requirement" do
    @req.validate_awarding(@awarding)
  end
end
