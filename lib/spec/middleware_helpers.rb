
module Spec #:nodoc:
  module MiddlewareHelpers
    def env_for(uri, opts = {})
      yield Rack::MockRequest.env_for(uri, opts)
    end
  end
end
