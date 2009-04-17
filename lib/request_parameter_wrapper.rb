
# Wrap request parameters, except 'id', in 'attributes'.
class RequestParameterWrapper
  
  def initialize(app)
    @app = app
  end
  
  def call(env)
    if env.has_key?('action_controller.request.request_parameters')
      env['action_controller.request.request_parameters'] =
        wrap_attributes(env['action_controller.request.request_parameters'])
    end
    @app.call(env)
  end
  
  private
  
  def wrap_attributes(params)
    attributes = params.reject { |key, value| key == 'id' }
    { 'attributes' => attributes, 'id' => params['id'] }
  end
end
