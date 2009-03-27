require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AwardRequirement do
  before(:each) do
    award = stub_model(Award)
    @req = AwardRequirement.create!(
      :award => award,
      :required_type => 'Person'
    )
    actor = Person.create!(:firstname => 'Get', :lastname => 'It')
    @awarding = Awarding.new(:award => award, :year => 2004)
  end

  it "adds an error to an awarding if it does not fulfill the requirement" do
    @req.validate_awarding(@awarding)
    @awarding.errors.on_base.should include('requires a recipient of type Person')
  end
end
