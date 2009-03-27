require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/movies/index.json.rb" do
  include MoviesHelper
  include Spec::JSONMatchers
  
  before(:each) do
    assigns[:movies] = [
      stub_model(Movie, :id => 1, :title => 'The first movie', :release_year => 2001) { |m|
        m.should_receive(:awardings).and_return([])
      },
      stub_model(Movie, :id => 2, :title => 'The second movie', :release_year => 2002) { |m|
        m.should_receive(:awardings).any_number_of_times.and_return([
          stub_model(Awarding) { |a| a.should_receive(:name).and_return('Oscar') },
          stub_model(Awarding) { |a| a.should_receive(:name).and_return('Karlheinz') }
        ])
      }
    ]
    assigns[:count] = 2
  end

  it "renders a list of movies" do
    template.template_format = :json
    render
    response.body.should be_json_eql <<-END
      {
        "identifier": "id",
        "totalCount": 2,
        "items": [
          {"release_year": 2001, "title": "The first movie", "id": "1"},
          {"release_year": 2002, "title": "The second movie", "id": "2",
            "awards": ["Oscar", "Karlheinz"]}
        ]
      }
    END
  end
end

