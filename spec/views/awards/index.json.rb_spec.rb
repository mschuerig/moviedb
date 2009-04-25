require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/awards/index.json.rb" do
  include AwardsHelper
  
  def stub_award(id, name, awardable = true)
    award = stub_model(Award, :id => id, :name => name)
    award.should_receive(:awardable?).any_number_of_times.and_return(awardable)
    award
  end
  
  def stub_top_level_award(id, name, awardable = false)
    award = stub_award(id, name, awardable)
    children = block_given? ? yield(award) : []
    award.should_receive(:children).any_number_of_times.and_return(children)
    award
  end
  
  before do
    assigns[:award_groups] = [
      stub_top_level_award(1, 'Oscar') { |aw|
        [stub_award(2, 'Best Mover'),  stub_award(3, 'Best Shaker')]
      },
      stub_top_level_award(4, 'Karlheinz')
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
          {"name": "Oscar", "id": "1", "awardings": { "$ref": "/awards/1/awardings" },
           "children": [
            {"id": "2", "name": "Best Mover", "awardings": {"$ref": "/awards/2/awardings" }},
            {"id": "3", "name": "Best Shaker", "awardings": {"$ref": "/awards/3/awardings" }}
           ]
          },
          {"name": "Karlheinz", "id": "4", "awardings": { "$ref": "/awards/4/awardings" }}
        ]
      }
    END
  end
end

