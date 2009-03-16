require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/people/edit.html.erb" do
  include PeopleHelper
  
  before(:each) do
    assigns[:person] = @person = stub_model(Person,
      :new_record? => false
    )
  end

  it "renders the edit person form" do
    render
    
    response.should have_tag("form[action=#{person_path(@person)}][method=post]") do
    end
  end
end


