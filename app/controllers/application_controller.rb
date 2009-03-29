# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  protected
  
  def parse_range_header(range = nil)
    range ||= request.headers['Range']
    if range && range =~ /items=(.*)-(.*)/
      first_item, last_item = $1.to_i, $2.to_i
      offset = first_item
      limit = last_item > 0 ? last_item - offset + 1 : nil
      { :offset => offset, :limit => limit }
    else
      {}
    end
  end
  
  def parse_order_params
    ### TODO use request.query_string
    order_clause = params.keys.grep(%r{^(/|\\)}).map do |attr|
      o = attr[1..-1]
      if attr[0..0] == '\\'
        o << ' DESC'
      end
      o
    end
    order_clause.empty? ? nil : order_clause.join(',')
  end

  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
