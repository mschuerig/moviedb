require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Any RESTful controller" do
  controller_name :movies
  
  before do
    @object = Movie.make
  end

  def self.it_should_return_not_found_status_for_an_object_that_never_existed(method, action)
    it "should return not found status for an object that never existed" do
      request.if_modified_since = nil
      request.if_none_match     = nil
      request.if_match          = nil
      send(method, action, :id => 0)
      response.should be_missing
    end
  end

  def self.it_should_return_gone_status_for_a_deleted_object(method, action)
    it "should return gone status for a delete object" do
      @object.destroy
      send(method, action, :id => @object.to_param)
      response.should be_gone
    end
  end

  describe "for a repeated index request" do
    before do
      @repeat_request = first_request :index
    end

    it "should not get fresh index again" do
      @repeat_request.call
      response.should be_not_modified
    end
  
    it "should get stale index again" do
      wait_for_changed_times
      update_object
      @repeat_request.call
      response.should be_success
    end
  end

  describe "for a repeated show request" do
    before do
      @repeat_request = first_request :show, :id => @object.to_param
    end

    it "should not show fresh object again" do
      @repeat_request.call
      response.should be_not_modified
    end

    it "should show stale object again" do
      wait_for_changed_times
      update_object
      @repeat_request.call
      response.should be_success
    end

    it_should_return_not_found_status_for_an_object_that_never_existed :get, :show
    it_should_return_gone_status_for_a_deleted_object :get, :show
  end

  describe "for an update request" do
    before do
      first_request :show, :id => @object.to_param
    end
  
    test "should update fresh object" do
      put :update, :id => @object.to_param
      response.should be_success
    end
  
    test "should prevent update of stale object" do
      wait_for_changed_times
      update_object
      put :update, :id => @object.to_param
      response.should be_precondition_failed
    end

    it_should_return_not_found_status_for_an_object_that_never_existed :put, :update
    it_should_return_gone_status_for_a_deleted_object :put, :update
  end

  describe "for a delete request" do
    before do
      first_request :show, :id => @object.to_param
    end

    it "should destroy an object with a fresh request" do
      lambda {
        first_request :show, :id => @object.to_param
        delete :destroy, :id => @object.to_param
        response.should be_success
      }.should change(Movie, :count).by(-1)
    end

    it "should decline to delete an object with a stale request" do
      first_request :show, :id => @object.to_param
      wait_for_changed_times
      update_object
      lambda {
        delete :destroy, :id => @object.to_param
        response.should be_precondition_failed
      }.should_not change(Movie, :count)
    end

    it_should_return_not_found_status_for_an_object_that_never_existed :delete, :destroy
    it_should_return_gone_status_for_a_deleted_object :delete, :destroy
  end


  def first_request(action, options = {})
    exec_request = lambda { get(action, options) }
    exec_request.call
    request.if_modified_since = response.last_modified
    request.if_none_match     = response.etag
    request.if_match          = response.etag
    exec_request
  end

  def update_object
    @object.update_attributes(:title => "New Title")
  end

  def wait_for_changed_times
    # we don't have a virtual clock, so let some real time pass
    # for a changed timestamp
    sleep 1
  end
end
