
require 'active_support/inflector'

# Map camelCase request parameter names to under_score.
class CamelCaseToUnderscoreMapper

  REQUEST_PARAMETERS = 'action_controller.request.request_parameters'.freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    if env.has_key?(REQUEST_PARAMETERS)
      env[REQUEST_PARAMETERS] = map_keys(env[REQUEST_PARAMETERS])
    end
    @app.call(env)
  end

  private

  def map_keys(value)
    case value
    when Hash
      map_hash(value)
    when Array
      value.map { |v| map_keys(v) }
    else
      value
    end
  end

  def map_hash(hash)
    hash.inject({}) do |h, (k, v)|
      h[k.to_s.underscore] = map_keys(v)
      h
    end
  end
end
