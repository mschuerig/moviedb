require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/movies/new.html.erb" do
  include MoviesHelper
  
  before(:each) do
    assigns[:movie] = stub_model(Movie,
      :new_record? => true
    )
  end

  it "renders new movie form" do
    render
    
    response.should have_tag("form[action=?][method=post]", movies_path) do
    end
  end
end


