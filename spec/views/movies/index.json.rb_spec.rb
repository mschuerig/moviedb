require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/movies/index.json.rb" do
  include MoviesHelper
  
  before do
    assigns[:movies] = [
      stub_model(Movie, :id => 1, :title => 'The first movie', :release_date => '2001-01-01') { |m|
        m.should_receive(:awardings).and_return([])
      },
      stub_model(Movie, :id => 2, :title => 'The second movie', :release_date => '2002-02-02') { |m|
        m.should_receive(:awardings).any_number_of_times.and_return([
          stub_model(Awarding, :name => 'Oscar') { |a|
            a.should_receive(:to_param).and_return('3')
          },
          stub_model(Awarding, :name => 'Karlheinz') { |a|
            a.should_receive(:to_param).and_return('4')
          }
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
          {"releaseDate": '2001-01-01', "title": "The first movie", "$ref": "/movies/1"},
          {"releaseDate": '2002-02-02', "title": "The second movie", "$ref": "/movies/2",
            "awards": [
              { "title": "Oscar", "$ref": "/awardings/3" },
              { "title": "Karlheinz", "$ref": "/awardings/4" }
             ]
          }
        ]
      }
    END
  end
end

