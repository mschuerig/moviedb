require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/movies/edit.html.erb" do
  include MoviesHelper
  
  before(:each) do
    assigns[:movie] = @movie = stub_model(Movie,
      :new_record? => false
    )
  end

  it "renders the edit movie form" do
    render
    
    response.should have_tag("form[action=#{movie_path(@movie)}][method=post]") do
    end
  end
end


