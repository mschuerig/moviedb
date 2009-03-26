require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/awards/new.html.erb" do
  include AwardsHelper
  
  before(:each) do
    assigns[:awards] = stub_model(Awards,
      :new_record? => true
    )
  end

  it "renders new awards form" do
    render
    
    response.should have_tag("form[action=?][method=post]", awards_path) do
    end
  end
end


