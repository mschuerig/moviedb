require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'rack/mock'

describe JSONQueryParser do
  before do
    @headers = { 'HTTP_ACCEPT' => 'application/json' }
    @app = lambda { |env| [200, {'Content-Type' => 'application/json'},
                           (env['action_controller.request.query_parameters'] || {})['query']]
    }
  end

  def env_for(uri, opts = {})
    yield Rack::MockRequest.env_for(uri, opts)
  end

  it "does not set query params if there is no query" do
    env_for("/resource/", :headers => @headers) do |env|
      parsed_query = JSONQueryParser.new(@app).call(env).last
      parsed_query.should be_nil
    end
  end
  
  it "does not overwrite existing query parameters"
  
  it "extracts a simple text condition" do
    env_for("/resource/?[?name%3D'Sammy']", :headers => @headers) do |env|
      parsed_query = JSONQueryParser.new(@app).call(env).last
      parsed_query.should == [{ :attribute => 'name', :compare => '=', :target => 'Sammy' }]
    end
  end
  
  it "extracts a simple numeric condition" do
    env_for("/resource/?[?age%3E%3D35]", :headers => @headers) do |env|
      parsed_query = JSONQueryParser.new(@app).call(env).last
      parsed_query.should == [{ :attribute => 'name', :compare => '>=', :target => 35 }]
    end
  end
  
  it "extracts multiple conditions" do
    env_for("/resource/?[?name='Sammy'][?age%4E35]", :headers => @headers) do |env|
      parsed_query = JSONQueryParser.new(@app).call(env).last
      parsed_query.should == [{ :attribute => 'name', :compare => '=', :target => 'Sammy' }]
    end
  end

end
