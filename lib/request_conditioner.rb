
class RequestConditioner
  extend ActiveSupport::Memoizable
  
  def initialize(request, options = {})
    @headers, @params = request.headers, request.parameters
    @allowed_attributes = options[:allowed]
    @condition_mappings = (options[:conditions] || {}).with_indifferent_access
    @order_mappings = (options[:order] || {}).with_indifferent_access
  end

  def find_options
    returning opts = {} do
      opts[:conditions] = conditions if conditions
#      opts[:offset]     = offset     if offset
#      opts[:limit]      = limit      if limit
      opts[:order]      = order      if order
    end
  end
  memoize :find_options
  
  def count_options
    returning opts = {} do
      opts[:conditions] = conditions if conditions
    end
  end
  memoize :count_options
  
  def conditions
    coerce_to_nil(condition_clause)
  end
  memoize :conditions
 
  def offset_limit
    parse_range_header
  end

  def offset
    parse_range_header[0]
  end
  
  def limit
    parse_range_header[1]
  end
  
  def order
    coerce_to_nil(order_clause)
  end
  memoize :order
  
  protected
  
  def parse_range_header
    range = @headers['Range']
    if range && range =~ /items=(.*)-(.*)/i
      first_item, last_item = $1.to_i, $2.to_i
      offset = first_item
      limit = last_item > 0 ? last_item - offset + 1 : nil
      [ offset, limit ]
    else
      [nil, nil]
    end
  end
  memoize :parse_range_header
  
  def order_clause
    cleaned_param(:order).map { |item|
      item[:dir] ||= 'ASC'
      template = @order_mappings[item[:attribute]] || ":attribute :dir"
      replace_named_bind_variables(template, item)
    }.join(', ')
  end
  
  def condition_clause
    query = cleaned_param(:query)
    templates = []
    targets = []
    query.each do |comparison|
      target = comparison[:target]
      op = comparison[:op]
      if op == '=' && target.include?('*')
        comparison[:op] = 'LIKE'
        target = target.gsub('*', '%')
      end
      templates << condition_template(comparison)
      targets << target
    end
    templates.empty? ? [] : [ templates.join(' AND ') ] + targets
  end

  def condition_template(comparison)
    template = @condition_mappings[comparison[:attribute]] || ":attribute :op ?"
    replace_named_bind_variables(template, comparison)
  end
  
  def cleaned_param(param)
    select_allowed_attributes(@allowed, Array(@params[param]))
  end
  
  def select_allowed_attributes(allowed, attribute_hashes)
    if allowed
      attribute_hashes.select { |h| allowed.include?(h[:attribute]) }
    else
      attribute_hashes
    end
  end

  def coerce_to_nil(a)
    a.blank? ? nil : a
  end
  
  # based on ActiveRecord::Base#replace_named_bind_variables
  def replace_named_bind_variables(statement, bind_vars) #:nodoc:
    statement.gsub(/(:?):([a-zA-Z]\w*)/) do
      if $1 == ':' # skip postgresql casts
        $& # return the whole match
      elsif bind_vars.include?(match = $2.to_sym)
        bind_vars[match]
      else
        raise ArgumentError, "missing value for :#{match} in #{statement}"
      end
    end
  end
end
