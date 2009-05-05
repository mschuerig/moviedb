
class RequestConditioner
  extend ActiveSupport::Memoizable
  
  def initialize(headers, parameters, options = {})
    @headers, @params = headers, parameters
    @renames = flatten_renames(options[:rename] || {})
    @allowed_attributes = Array(options[:allowed]).map(&:to_s) if options[:allowed]
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
  
  def first_item
    parse_range_header[2]
  end

  def last_item
    parse_range_header[3]
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
      [ offset, limit, first_item, last_item ]
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
      template = condition_template(comparison)
      templates << template
      targets += [target] * template.count('?')
    end
    templates.empty? ? [] : [ templates.join(' AND ') ] + targets
  end

  def condition_template(comparison)
    template = @condition_mappings[comparison[:attribute]] || ":attribute :op ?"
    replace_named_bind_variables(template, comparison)
  end
  
  def cleaned_param(param)
    renamed_hashes = rename_attributes(Array(@params[param]))
    select_allowed_attributes(@allowed_attributes, renamed_hashes)
  end
  
  def select_allowed_attributes(allowed, attribute_hashes)
    if allowed
      attribute_hashes.select { |h| allowed.include?(h[:attribute]) }
    else
      attribute_hashes
    end
  end
  
  def rename_attributes(attribute_hashes)
    attribute_hashes.inject([]) do |renamed, hash|
      hash[:attribute] = @renames[hash[:attribute]] || hash[:attribute]
      renamed << hash
    end
  end

  def coerce_to_nil(a)
    a.blank? ? nil : a
  end
  
  def flatten_renames(mappings)
    mappings.inject({}) do |flattened, (from_keys, to_key)|
      Array(from_keys).each do |from_key|
        flattened[from_key.to_s] = to_key.to_s
      end
      flattened
    end
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
