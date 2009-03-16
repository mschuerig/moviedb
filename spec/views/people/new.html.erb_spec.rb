require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/people/new.html.erb" do
  include PeopleHelper
  
  before(:each) do
    assigns[:person] = stub_model(Person,
      :new_record? => true
    )
  end

  it "renders new person form" do
    render
    
    response.should have_tag("form[action=?][method=post]", people_path) do
    end
  end
end


