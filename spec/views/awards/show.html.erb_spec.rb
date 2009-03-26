require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/awards/show.html.erb" do
  include AwardsHelper
  before(:each) do
    assigns[:awards] = @awards = stub_model(Awards)
  end

  it "renders attributes in <p>" do
    render
  end
end

