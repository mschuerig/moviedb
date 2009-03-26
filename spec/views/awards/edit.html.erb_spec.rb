require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/awards/edit.html.erb" do
  include AwardsHelper
  
  before(:each) do
    assigns[:awards] = @awards = stub_model(Awards,
      :new_record? => false
    )
  end

  it "renders the edit awards form" do
    render
    
    response.should have_tag("form[action=#{awards_path(@awards)}][method=post]") do
    end
  end
end


