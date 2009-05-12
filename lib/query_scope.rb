
module QueryScope
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def query_scope(options = {}, &config_block)
      model_class = extract_resource!(options)
      builder = QueryScopeBuilder.new(config_block)

      around_filter(options) do |controller, action|
        req = builder.build_request_conditioner(controller.request)
        controller.instance_variable_set(:@offset_limit, req.offset_limit)
        model_class.send(:with_scope, :find => req.find_options, &action)

        total = controller.instance_variable_get(:@count)
        if total
          if total == 0
            first_item = last_item = 0
          else
            first_item = req.first_item || 0
            last_item  = total - 1
            last_item = [req.last_item, last_item].min if req.last_item
          end
          range = "items #{first_item}-#{last_item}/#{total}"
          controller.response.headers['Content-Range'] = range
        end
      end
    end

    def extract_resource!(options)
      resource = options.delete(:resource) || self.controller_name
      resource.to_s.singularize.camelize.constantize
    end
  end

  private

  class QueryScopeBuilder
    def initialize(config_block)
      @renames            = {}
      @condition_mappings = {}
      @order_mappings     = {}
      @allowed_attributes = []
      instance_eval(&config_block)
    end
    def allow(*attributes)
      @allowed_attributes += attributes
    end
    def rename(mapping)
      @renames.merge!(mapping)
    end
    def condition(mapping)
      @condition_mappings.merge!(mapping)
    end
    def order(mapping)
      @order_mappings.merge!(mapping)
    end
    def build_request_conditioner(request)
      RequestConditioner.new(request.headers, request.parameters, {
        :allowed    => @allowed_attributes.empty? ? nil : @allowed_attributes,
        :rename     => @renames,
        :conditions => @condition_mappings,
        :order      => @order_mappings
      })
    end
  end

end
