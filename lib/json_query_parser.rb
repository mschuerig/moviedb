
require 'rack/utils'

# Parse a (small) subset of JSON Query
# see http://www.sitepen.com/blog/2008/07/16/jsonquery-data-querying-beyond-jsonpath/
class JSONQueryParser
  QUERY_PARAMETERS = 'action_controller.request.query_parameters'.freeze
  COMPARATORS = ['=', '<', '<=', '>=', '>'].join('|').freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    unless env.has_key?(QUERY_PARAMETERS)
      query = Rack::Utils.unescape(env['QUERY_STRING'].to_s)
      conditions = []
      orders = []
      query.scan(%r{\[.*?\]}) do |bracket|
        case bracket
        when %r{^\[\?([[:alnum:]_]+)[[:blank:]]*(#{COMPARATORS})[[:blank:]]*'(.*?)'\]$}
          conditions << build_condition($1, $2, $3)
        when %r{^\[\?([[:alnum:]_]+)[[:blank:]]*(#{COMPARATORS})[[:blank:]]*([[:digit:].,]*?)\]$}
          conditions << build_condition($1, $2, $3)
        when %r{^\[/(.+?)\]}
          orders << build_order($1)
        when %r{^\[\\(.+?)\]}
          orders << build_order($1, 'DESC')
        end
      end
      env[QUERY_PARAMETERS] ||= {}
      env[QUERY_PARAMETERS]['query'] = conditions unless conditions.empty?
      env[QUERY_PARAMETERS]['order'] = orders unless orders.empty?
    end
    @app.call(env)
  end

  private

  def build_condition(attribute, compare, target)
    { :attribute => Rack::Utils.unescape(attribute.underscore), :op => Rack::Utils.unescape(compare), :target => Rack::Utils.unescape(target) }
  end

  def build_order(attribute, direction = nil)
    order = { :attribute => Rack::Utils.unescape(attribute.underscore) }
    order[:dir] = direction if direction
    order
  end
end
