require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AwardsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "awards", :action => "index").should == "/awards"
    end

    it "maps #new" do
      route_for(:controller => "awards", :action => "new").should == "/awards/new"
    end

    it "maps #show" do
      route_for(:controller => "awards", :action => "show", :id => "1").should == "/awards/1"
    end

    it "maps #edit" do
      route_for(:controller => "awards", :action => "edit", :id => "1").should == "/awards/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "awards", :action => "create").should == {:path => "/awards", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "awards", :action => "update", :id => "1").should == {:path =>"/awards/1", :method => :put}
  end

    it "maps #destroy" do
      route_for(:controller => "awards", :action => "destroy", :id => "1").should == {:path =>"/awards/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/awards").should == {:controller => "awards", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/awards/new").should == {:controller => "awards", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/awards").should == {:controller => "awards", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/awards/1").should == {:controller => "awards", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/awards/1/edit").should == {:controller => "awards", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/awards/1").should == {:controller => "awards", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/awards/1").should == {:controller => "awards", :action => "destroy", :id => "1"}
    end
  end
end
