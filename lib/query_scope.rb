
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
      @allowed_attributes = []
      @condition_mappings = {}
      @order_mappings = {}
      instance_eval(&config_block)
    end
    def allow(*attributes)
      @allowed_attributes << attributes
    end
    def condition(mapping)
      @condition_mappings.merge!(mapping)
    end
    def order(mapping)
      @order_mappings.merge!(mapping)
    end
    def build_request_conditioner(request)
      RequestConditioner.new(request, { 
        :allowed    => @allowed_attributes,
        :conditions => @condition_mappings,
        :order      => @order_mappings
      })
    end
  end

end
