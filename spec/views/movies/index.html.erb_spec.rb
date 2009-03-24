require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/movies/index.html.erb" do
  include MoviesHelper
  
  before(:each) do
    assigns[:movies] = [
      stub_model(Movie),
      stub_model(Movie)
    ]
  end

  it "renders a list of movies" do
    render
  end
end

