
class JSONQueryParser
  def initialize(app)
    @app = app
  end
  
  def call(env)
    unless env.has_key?('action_controller.request.query_parameters')
      query = env['QUERY_STRING'].to_s
#      env['QUERY_STRING'] = ''
#      env['action_controller.request.query_parameters'] = { :blah => :foo }.with_indifferent_access
    end
    @app.call(env)
  end
end
