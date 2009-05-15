require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/movies/index.json.rb" do
  include MoviesHelper

  def stub_award(id, name, awardable = true)
    award = stub_model(Award, :id => id, :name => name)
    award.should_receive(:awardable?).any_number_of_times.and_return(awardable)
    award
  end

  def stub_awarding(name, id, year, award)
    award = stub_award(award[:id], award[:name]) if award.kind_of?(Hash)
    stub_model(Awarding, :id => id, :name => name, :year => year, :award => award)
  end

  before do
    assigns[:movies] = [
      stub_model(Movie, :id => 1, :title => 'The first movie', :release_date => '2001-01-01') { |m|
        m.should_receive(:awardings).and_return([])
      },
      stub_model(Movie, :id => 2, :title => 'The second movie', :release_date => '2002-02-02') { |m|
        m.should_receive(:awardings).any_number_of_times.and_return([
          stub_awarding('Best Actor',   3, 2002, :name => 'Oscar', :id => 5),
          stub_awarding('Best Schmock', 4, 2002, :name => 'Karlheinz', :id => 6)
        ])
      }
    ]
    assigns[:count] = 2
  end

  it "renders a list of movies" do
    template.template_format = :json
    render
    response.body.should be_json_eql <<-END
      [
        {"releaseDate": '2001-01-01', "title": "The first movie", "id": "/movies/1", "$ref": "/movies/1",
          "awardings": []
        },
        {"releaseDate": '2002-02-02', "title": "The second movie", "id": "/movies/2", "$ref": "/movies/2",
          "awardings": [
            { "title": "Best Actor",   "year": 2002, "id": "/awardings/3", "$ref": "/awardings/3", "award": { "$ref": "/awards/5" } },
            { "title": "Best Schmock", "year": 2002, "id": "/awardings/4", "$ref": "/awardings/4", "award": { "$ref": "/awards/6" } }
           ]
        }
      ]
    END
  end
end

