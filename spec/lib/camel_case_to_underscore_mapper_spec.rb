require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'rack/mock'
require 'spec/middleware_helpers'

describe CamelCaseToUnderscoreMapper do
  include Spec::MiddlewareHelpers

  before do
    @headers = { 'HTTP_ACCEPT' => 'application/json' }
    @app = lambda { |env| [200, {'Content-Type' => 'application/json'},
                           env[CamelCaseToUnderscoreMapper::REQUEST_PARAMETERS]]
    }
  end

  def set_params(env, params)
    env[CamelCaseToUnderscoreMapper::REQUEST_PARAMETERS] = params
  end
  
  it "does not set request parameters if there aren't any already" do
    env_for("/resource/", :headers => @headers) do |env|
      request_parameters = CamelCaseToUnderscoreMapper.new(@app).call(env).last
      request_parameters.should be_nil
    end
  end
  
  it "maps top-level hash keys" do
    env_for("/resource/", :headers => @headers) do |env|
      set_params(env, 'CamelCase' => 1, 'under_score' => 2)
      request_parameters = CamelCaseToUnderscoreMapper.new(@app).call(env).last
      request_parameters.should == { 'camel_case' => 1, 'under_score' => 2 }
    end
  end
  
  it "maps array-nested hash keys" do
    env_for("/resource/", :headers => @headers) do |env|
      set_params(env, [{ 'CamelCase' => 1, 'under_score' => 2 }])
      request_parameters = CamelCaseToUnderscoreMapper.new(@app).call(env).last
      request_parameters.should == [{ 'camel_case' => 1, 'under_score' => 2 }]
    end
  end

  it "maps hash-nested hash keys" do
    env_for("/resource/", :headers => @headers) do |env|
      set_params(env, 'HaSh' => { 'CamelCase' => 1, 'under_score' => 2 })
      request_parameters = CamelCaseToUnderscoreMapper.new(@app).call(env).last
      request_parameters.should == { 'ha_sh' => { 'camel_case' => 1, 'under_score' => 2 }}
    end
  end

end
