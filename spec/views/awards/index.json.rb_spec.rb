require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/awards/index.json.rb" do
  include AwardsHelper
  include Spec::JSONMatchers
  
  before(:each) do
    assigns[:award_groups] = [
      stub_model(AwardGroup, :id => 1, :name => 'Oscar') { |ag|
        ag.should_receive(:children).any_number_of_times.and_return([
          stub_model(Award, :id => 2, :name => 'Best Mover'),
          stub_model(Award, :id => 3, :name => 'Best Shaker')
        ])
      },
      stub_model(AwardGroup, :id => 4, :name => 'Karlheinz') { |a|
        a.should_receive(:children).and_return([])
      }
    ]
  end

  it "renders a tree of awards" do
    template.template_format = :json
    render
    response.body.should be_json_eql <<-END
      {
        "label": "name",
        "identifier": "id",
        "items": [
          {"name": "Oscar", "id": "1",
           "awards": [
            {"id": "2", "name": "Best Mover"},
            {"id": "3", "name": "Best Shaker"}
           ]},
          {"name": "Karlheinz", "id": "4"}
        ]
      }
    END
  end
end

