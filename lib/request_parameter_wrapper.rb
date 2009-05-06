
# Wrap request parameters, except 'id', in 'attributes'.
class RequestParameterWrapper

  REQUEST_PARAMETERS = 'action_controller.request.request_parameters'.freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    if env.has_key?(REQUEST_PARAMETERS)
      env[REQUEST_PARAMETERS] = wrap_attributes(env[REQUEST_PARAMETERS])
    end
    @app.call(env)
  end

  private

  def wrap_attributes(params)
    attributes = params.reject { |key, value| key == 'id' }
    returning wrapped = {} do
      wrapped['attributes'] = attributes unless attributes.empty?
      wrapped['id'] = params['id'] unless params['id'].blank?
    end
  end
end
