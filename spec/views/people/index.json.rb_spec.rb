require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/people/index.json.rb" do
  include PeopleHelper
  include Spec::JSONMatchers
  
  before(:each) do
    person = stub_model(Person, :id => 1,
      :firstname => 'Clint', :lastname => 'Easterbunny', :date_of_birth => '2008-03-23')
    assigns[:people] = [person]
    assigns[:count] = 1
  end

  it "renders a list of people" do
    template.template_format = :json
    render
    response.body.should be_json_eql <<-END
      {
        "identifier": "id",
        "totalCount": 1,
        "items": [
          {"id": 1, "name": "Clint Easterbunny", "dob": "2008-03-23"}
        ]
      }
    END
  end
end
