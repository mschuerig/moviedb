require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'rack/mock'

describe JSONQueryParser do
  before do
    @headers = { 'HTTP_ACCEPT' => 'application/json' }
    @app = lambda { |env| [200, {'Content-Type' => 'application/json'}, env['PATH_INFO']] }
  end

  def env_for(uri, opts = {})
    yield Rack::MockRequest.env_for(uri, opts)
  end

  it "runs in circles" do
#    q = %{/people/[/@['name']][:25]}
    env_for("/resource/?[?name='Sammy']", :headers => @headers) do |env|
      JSONQueryParser.new(@app).call(env)
      puts "*** ENV: #{env.inspect}"
    end
  end
  
end
