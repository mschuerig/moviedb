require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AwardsController do

  def mock_award(stubs={})
    @mock_award ||= mock_model(Award, stubs)
  end

  def mock_top_level_award(stubs={})
    @mock_top_level_award ||= mock_model(Award, stubs)
  end
  
  describe "GET index" do
    describe "with mime type of json" do
      
      it "exposes the top-level award groups" do
        Award.should_receive(:top_level).and_return([mock_top_level_award])
        get :index, :format => 'json'
        assigns[:award_groups].should == [mock_top_level_award]
      end

      it "renders the awards/index.json.rb template" do
        Award.should_receive(:top_level).and_return([mock_top_level_award])
        get :index, :format => 'json'
        response.should render_template('awards/index.json.rb')
      end
    end
  end

=begin
  describe "GET index" do

    it "exposes all awards as @awards" do
      Award.should_receive(:find).with(:all).and_return([mock_award])
      get :index
      assigns[:awards].should == [mock_award]
    end

    describe "with mime type of xml" do
  
      it "renders all awards as xml" do
        Award.should_receive(:find).with(:all).and_return(awards = mock("Array of Awards"))
        awards.should_receive(:to_xml).and_return("generated XML")
        get :index, :format => 'xml'
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "GET show" do

    it "exposes the requested awards as @awards" do
      Award.should_receive(:find).with("37").and_return(mock_award)
      get :show, :id => "37"
      assigns[:awards].should equal(mock_award)
    end
    
    describe "with mime type of xml" do

      it "renders the requested awards as xml" do
        Award.should_receive(:find).with("37").and_return(mock_award)
        mock_award.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37", :format => 'xml'
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "GET new" do
  
    it "exposes a new awards as @awards" do
      Award.should_receive(:new).and_return(mock_award)
      get :new
      assigns[:awards].should equal(mock_award)
    end

  end

  describe "GET edit" do
  
    it "exposes the requested awards as @awards" do
      Award.should_receive(:find).with("37").and_return(mock_award)
      get :edit, :id => "37"
      assigns[:awards].should equal(mock_award)
    end

  end

  describe "POST create" do

    describe "with valid params" do
      
      it "exposes a newly created awards as @awards" do
        Award.should_receive(:new).with({'these' => 'params'}).and_return(mock_award(:save => true))
        post :create, :awards => {:these => 'params'}
        assigns(:awards).should equal(mock_award)
      end

      it "redirects to the created awards" do
        Award.stub!(:new).and_return(mock_award(:save => true))
        post :create, :awards => {}
        response.should redirect_to(award_url(mock_award))
      end
      
    end
    
    describe "with invalid params" do

      it "exposes a newly created but unsaved awards as @awards" do
        Award.stub!(:new).with({'these' => 'params'}).and_return(mock_award(:save => false))
        post :create, :awards => {:these => 'params'}
        assigns(:awards).should equal(mock_award)
      end

      it "re-renders the 'new' template" do
        Award.stub!(:new).and_return(mock_award(:save => false))
        post :create, :awards => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "PUT udpate" do

    describe "with valid params" do

      it "updates the requested awards" do
        Award.should_receive(:find).with("37").and_return(mock_award)
        mock_award.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :awards => {:these => 'params'}
      end

      it "exposes the requested awards as @awards" do
        Award.stub!(:find).and_return(mock_award(:update_attributes => true))
        put :update, :id => "1"
        assigns(:awards).should equal(mock_award)
      end

      it "redirects to the awards" do
        Award.stub!(:find).and_return(mock_award(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(award_url(mock_award))
      end

    end
    
    describe "with invalid params" do

      it "updates the requested awards" do
        Award.should_receive(:find).with("37").and_return(mock_award)
        mock_award.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :awards => {:these => 'params'}
      end

      it "exposes the awards as @awards" do
        Award.stub!(:find).and_return(mock_award(:update_attributes => false))
        put :update, :id => "1"
        assigns(:awards).should equal(mock_award)
      end

      it "re-renders the 'edit' template" do
        Award.stub!(:find).and_return(mock_award(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "DELETE destroy" do

    it "destroys the requested awards" do
      Award.should_receive(:find).with("37").and_return(mock_award)
      mock_award.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the awards list" do
      Award.stub!(:find).and_return(mock_award(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(awards_url)
    end

  end
=end
end
