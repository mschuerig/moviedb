require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Any RESTful controller" do
  controller_name :movies
  
  before do
    @object = Movie.make
  end

  describe "for repeated index request" do
    before do
      @repeat_request = first_request :index
    end

    it "should not get fresh index again" do
      @repeat_request.call
      should respond_with(:not_modified)
    end
  
    it "should get stale index again" do
      wait_for_changed_times
      update_object
      @repeat_request.call
      response.should be_success
    end
  end

  describe "for repeated show request" do
    before do
      @repeat_request = first_request :show, :id => @object.to_param
    end

    it "should not show fresh object again" do
      @repeat_request.call
      should respond_with(:not_modified)
    end

    it "should show stale object again" do
      wait_for_changed_times
      update_object
      @repeat_request.call
      response.should be_success
    end
  end

  describe "for repeated show request" do
    before do
      @repeat_request = first_request :show, :id => @object.to_param
    end
  
    test "should update fresh object" do
      put :update, :id => @object.to_param
      response.should be_success
    end
  
    test "should prevent update of stale object" do
      wait_for_changed_times
      update_object
      put :update, :id => @object.to_param
      should respond_with(:precondition_failed)
    end
  end

  def first_request(action, options = {})
    exec_request = lambda { get(action, options) }
    exec_request.call
    @request.if_modified_since = @response.last_modified
    @request.if_none_match     = @response.etag
    @request.if_match          = @response.etag
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
