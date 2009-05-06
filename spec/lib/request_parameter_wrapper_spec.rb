require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'rack/mock'
require 'spec/middleware_helpers'

describe RequestParameterWrapper do
  include Spec::MiddlewareHelpers

  before do
    @headers = { 'HTTP_ACCEPT' => 'application/json' }
    @app = lambda { |env| [200, {'Content-Type' => 'application/json'},
                           env[RequestParameterWrapper::REQUEST_PARAMETERS]]
    }
  end

  def set_params(env, params)
    env[CamelCaseToUnderscoreMapper::REQUEST_PARAMETERS] = params
  end

  it "does not set request parameters if there aren't any already" do
    env_for("/resource/", :headers => @headers) do |env|
      request_parameters = RequestParameterWrapper.new(@app).call(env).last
      request_parameters.should be_nil
    end
  end

  it "does not add junk to request parameters" do
    env_for("/resource/", :headers => @headers) do |env|
      set_params(env, {})
      request_parameters = RequestParameterWrapper.new(@app).call(env).last
      request_parameters.should == {}
    end
  end

  it "does not wrap id parameter" do
    env_for("/resource/", :headers => @headers) do |env|
      set_params(env, 'id' => 1)
      request_parameters = RequestParameterWrapper.new(@app).call(env).last
      request_parameters.should == { 'id' => 1 }
    end
  end

  it "wraps parameters below top-level :attributes" do
    env_for("/resource/", :headers => @headers) do |env|
      set_params(env, 'id' => 1, 'name' => 'me')
      request_parameters = RequestParameterWrapper.new(@app).call(env).last
      request_parameters.should == { 'id' => 1, 'attributes' => { 'name' => 'me' }}
    end
  end
end
