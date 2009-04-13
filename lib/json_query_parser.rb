
class JSONQueryParser
  COMPARATORS = ['=', '<', '=<', '>=', '>'].map { |c| CGI.escape(c) }.join('|').freeze
  
  def initialize(app)
    @app = app
  end
  
  def call(env)
    unless env.has_key?('action_controller.request.query_parameters')
      query = env['QUERY_STRING'].to_s
      conditions = []
      query.scan(/\[.*?\]/) do |condition|
        case condition
        when /^\[\?([[:alnum:]_]+)[[:blank:]]*(#{COMPARATORS})[[:blank:]]*'(.*?)']$/
          conditions << build_condition($1, $2, $3)
        when /^\[\?([[:alnum:]_]+)[[:blank:]]*(#{COMPARATORS})[[:blank:]]*([[:digit].,]*?)]$/
          conditions << build_condition($1, $2, $3)
        end
      end
      unless conditions.empty?
        env['action_controller.request.query_parameters'] ||= {}
        env['action_controller.request.query_parameters']['query'] = conditions
      end
    end
    @app.call(env)
  end
  
  def build_condition(attrirbute, compare, target)
    { :attribute => CGI::unescape(attribute), :compare => CGI::unescape(compare), :target => CGI::unescape(target) }
  end
end
