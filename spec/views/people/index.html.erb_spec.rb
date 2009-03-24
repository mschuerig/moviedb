require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/people/index.html.erb" do
  include PeopleHelper
  
  before(:each) do
    assigns[:people] = [
      stub_model(Person),
      stub_model(Person)
    ]
  end

  it "renders a list of people" do
    render
  end
end

