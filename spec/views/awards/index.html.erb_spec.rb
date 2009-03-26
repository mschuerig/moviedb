require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/awards/index.html.erb" do
  include AwardsHelper
  
  before(:each) do
    assigns[:awards] = [
      stub_model(Awards),
      stub_model(Awards)
    ]
  end

  it "renders a list of awards" do
    render
  end
end

