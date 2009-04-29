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
      
      def expect_top_level_awards_are_retrieved
        Award.should_receive(:top_level).and_return(mock_scope = mock('scope'))
        mock_scope.should_receive(:all).and_return([mock_top_level_award])
      end
      
      it "exposes the top-level award groups" do
        expect_top_level_awards_are_retrieved
        get :index, :format => 'json'
        assigns[:award_groups].should == [mock_top_level_award]
      end

      it "renders the awards/index.json.rb template" do
        expect_top_level_awards_are_retrieved
        get :index, :format => 'json'
        response.should render_template('awards/index.json.rb')
      end
    end
  end
end
