
module Spec
  module MiddlewareHelpers
    def env_for(uri, opts = {})
      yield Rack::MockRequest.env_for(uri, opts)
    end
  end
end
