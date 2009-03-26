require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AwardsController do

  def mock_awards(stubs={})
    @mock_awards ||= mock_model(Awards, stubs)
  end
  
  describe "GET index" do

    it "exposes all awards as @awards" do
      Awards.should_receive(:find).with(:all).and_return([mock_awards])
      get :index
      assigns[:awards].should == [mock_awards]
    end

    describe "with mime type of xml" do
  
      it "renders all awards as xml" do
        Awards.should_receive(:find).with(:all).and_return(awards = mock("Array of Awards"))
        awards.should_receive(:to_xml).and_return("generated XML")
        get :index, :format => 'xml'
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "GET show" do

    it "exposes the requested awards as @awards" do
      Awards.should_receive(:find).with("37").and_return(mock_awards)
      get :show, :id => "37"
      assigns[:awards].should equal(mock_awards)
    end
    
    describe "with mime type of xml" do

      it "renders the requested awards as xml" do
        Awards.should_receive(:find).with("37").and_return(mock_awards)
        mock_awards.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37", :format => 'xml'
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "GET new" do
  
    it "exposes a new awards as @awards" do
      Awards.should_receive(:new).and_return(mock_awards)
      get :new
      assigns[:awards].should equal(mock_awards)
    end

  end

  describe "GET edit" do
  
    it "exposes the requested awards as @awards" do
      Awards.should_receive(:find).with("37").and_return(mock_awards)
      get :edit, :id => "37"
      assigns[:awards].should equal(mock_awards)
    end

  end

  describe "POST create" do

    describe "with valid params" do
      
      it "exposes a newly created awards as @awards" do
        Awards.should_receive(:new).with({'these' => 'params'}).and_return(mock_awards(:save => true))
        post :create, :awards => {:these => 'params'}
        assigns(:awards).should equal(mock_awards)
      end

      it "redirects to the created awards" do
        Awards.stub!(:new).and_return(mock_awards(:save => true))
        post :create, :awards => {}
        response.should redirect_to(award_url(mock_awards))
      end
      
    end
    
    describe "with invalid params" do

      it "exposes a newly created but unsaved awards as @awards" do
        Awards.stub!(:new).with({'these' => 'params'}).and_return(mock_awards(:save => false))
        post :create, :awards => {:these => 'params'}
        assigns(:awards).should equal(mock_awards)
      end

      it "re-renders the 'new' template" do
        Awards.stub!(:new).and_return(mock_awards(:save => false))
        post :create, :awards => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "PUT udpate" do

    describe "with valid params" do

      it "updates the requested awards" do
        Awards.should_receive(:find).with("37").and_return(mock_awards)
        mock_awards.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :awards => {:these => 'params'}
      end

      it "exposes the requested awards as @awards" do
        Awards.stub!(:find).and_return(mock_awards(:update_attributes => true))
        put :update, :id => "1"
        assigns(:awards).should equal(mock_awards)
      end

      it "redirects to the awards" do
        Awards.stub!(:find).and_return(mock_awards(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(award_url(mock_awards))
      end

    end
    
    describe "with invalid params" do

      it "updates the requested awards" do
        Awards.should_receive(:find).with("37").and_return(mock_awards)
        mock_awards.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :awards => {:these => 'params'}
      end

      it "exposes the awards as @awards" do
        Awards.stub!(:find).and_return(mock_awards(:update_attributes => false))
        put :update, :id => "1"
        assigns(:awards).should equal(mock_awards)
      end

      it "re-renders the 'edit' template" do
        Awards.stub!(:find).and_return(mock_awards(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "DELETE destroy" do

    it "destroys the requested awards" do
      Awards.should_receive(:find).with("37").and_return(mock_awards)
      mock_awards.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the awards list" do
      Awards.stub!(:find).and_return(mock_awards(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(awards_url)
    end

  end

end
