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
  
  def order_clause(*args)
    mappings = args.extract_options!
    order = select_allowed_attributes(mappings.delete(:allowed), args[0] || params[:order])
    return nil if order.blank?
    unless mappings.empty?
      order.each do |o|
        old_attr = o[:attribute]
        if new_attr = mappings[old_attr]
          o[:attribute] = new_attr
        end
      end
    end
    order.map { |o|
      o[:direction] ? "#{o[:attribute]} #{o[:direction]}" : o[:attribute]
    }.join(', ')
  end
  
  def condition_clause(*args)
    mappings = args.extract_options!
    query = select_allowed_attributes(mappings.delete(:allowed), args[0] || params[:query])
    ### TODO check for permissible attributes: :allowed
    conditions = nil
    if query
      templates = []
      targets = []
      query.each do |comparison|
        target = comparison[:target]
        op = comparison[:op]
        if op == '=' && target.include?('*')
          op = 'LIKE'
          target = target.gsub('*', '%')
        end
        attr = comparison[:attribute]
        templates <<
          if template = mappings[attr]
            template
          else
            "(LOWER(#{attr}) #{op} LOWER(?))"
          end
        targets << target
      end
      conditions = [ templates.join(' AND ') ] + targets
    end
    conditions
  end
  
  def select_allowed_attributes(allowed, attribute_hashes)
    if allowed
      attribute_hashes.select { |h| allowed.include?(h[:attribute]) }
    else
      attribute_hashes
    end
  end
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
