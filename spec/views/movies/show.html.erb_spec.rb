require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/movies/show.html.erb" do
  include MoviesHelper
  before(:each) do
    assigns[:movie] = @movie = stub_model(Movie)
  end

  it "renders attributes in <p>" do
    render
  end
end

