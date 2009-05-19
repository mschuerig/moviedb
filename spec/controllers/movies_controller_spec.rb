require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'spec/mocks/scope_expectation'

describe MoviesController do

  def mock_movie_item(stubs={})
    @mock_movie_item ||= mock_model(MovieItem, stubs)
  end

  def mock_movie(stubs={})
    @mock_movie ||= mock_model(Movie, stubs)
  end

  def expect_movie_retrievals(options = {}, find_scope = nil)
    scopes = find_scope ? { :find => find_scope } : {}
    MovieItem.should_receive(:all).with(options).within_scope(MovieItem, scopes).and_return([])
    MovieItem.should_receive(:count).and_return(0)
  end

  describe "GET index" do
    describe "with mime type of json" do
      before do
        @find_all_options = {
          :offset => nil,
          :limit => nil
        }
      end

      it "exposes the requested movies" do
        expect_movie_retrievals(@find_all_options)
        get :index, :format => 'json'
        assigns[:movies].should == []
        assigns[:count].should == 0
      end

      it "sets the Content-Range header" do
        pending do ### TODO the header is set, but apparently on another response object
          response.headers['Content-Range'].should == 'items 0-0/0'
        end
      end

      it "renders the movies/index.json.rb template" do
        expect_movie_retrievals(@find_all_options)
        get :index, :format => 'json'
        response.should render_template('movies/index.json.rb')
      end

      describe "and Range header" do
        before do
          request.env['Range'] = 'items=10-60'
        end

        it "retrieves only the requested range of movies" do
          expect_movie_retrievals(@find_all_options.merge(:offset => 10, :limit => 51))
          get :index, :format => 'json'
        end
      end

      describe "and order params" do
        it "orders by title ascending for /title" do
          expect_movie_retrievals(@find_all_options,
            :order => 'title ASC', :include => { :awardings => :award })
          get :index, :order => [{:attribute => 'title' }], :format => 'json'
        end

        it "orders by title descending for \\title" do
          expect_movie_retrievals(@find_all_options,
            :order => 'title DESC', :include => { :awardings => :award })
          get :index, :order => [{:attribute => 'title', :dir => 'DESC' }], :format => 'json'
        end
      end
    end
  end

  describe "GET show" do
    describe "with mime type of json" do

      it "renders the requested movie as json" do
        Movie.should_receive(:find).with("37").and_return(mock_movie)
        get :show, :id => "37", :format => 'json'
        response.should render_template('movies/show.json.rb')
        assigns(:movie).should equal(mock_movie)
      end
    end
  end

  describe "POST create" do

    describe "with valid params" do

      it "exposes a newly created movie as @movie" do
        Movie.should_receive(:new).with({'these' => 'params'}).and_return(mock_movie(:save => true))
        post :create, :attributes => {:these => 'params'}
        response.should render_template('movies/show.json.rb')
        assigns(:movie).should equal(mock_movie)
      end

      it "points in the location header to the created movie" do
        Movie.stub!(:new).and_return(mock_movie(:id => 42, :save => true))
        post :create, :movie => {}
        response.headers['location'].should == '/movies/42'
      end
    end

=begin
    describe "with invalid params" do

      it "exposes a newly created but unsaved movie as @movie" do
        Movie.stub!(:new).with({'these' => 'params'}).and_return(mock_movie(:save => false))
        post :create, :movie => {:these => 'params'}
        assigns(:movie).should equal(mock_movie)
      end

      it "re-renders the 'new' template" do
        Movie.stub!(:new).and_return(mock_movie(:save => false))
        post :create, :movie => {}
        response.should render_template('new')
      end
    end
=end

  end

=begin
  describe "PUT update" do

    describe "with valid params" do

      it "updates the requested movie" do
        Movie.should_receive(:find).with("37").and_return(mock_movie)
        mock_movie.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :movie => {:these => 'params'}
      end

      it "exposes the requested movie as @movie" do
        Movie.stub!(:find).and_return(mock_movie(:update_attributes => true))
        put :update, :id => "1"
        assigns(:movie).should equal(mock_movie)
      end

      it "redirects to the movie" do
        Movie.stub!(:find).and_return(mock_movie(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(movie_url(mock_movie))
      end

    end

    describe "with invalid params" do

      it "updates the requested movie" do
        Movie.should_receive(:find).with("37").and_return(mock_movie)
        mock_movie.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :movie => {:these => 'params'}
      end

      it "exposes the movie as @movie" do
        Movie.stub!(:find).and_return(mock_movie(:update_attributes => false))
        put :update, :id => "1"
        assigns(:movie).should equal(mock_movie)
      end

      it "re-renders the 'edit' template" do
        Movie.stub!(:find).and_return(mock_movie(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "DELETE destroy" do

    it "destroys the requested movie" do
      Movie.should_receive(:find).with("37").and_return(mock_movie)
      mock_movie.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the movies list" do
      Movie.stub!(:find).and_return(mock_movie(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(movies_url)
    end

  end
=end
end
