
module ActiveRecord
  class View < Base
    self.abstract_class = true
    
    def readonly?
      true
    end
    
    class << self
      def based_on(klass)
        define_method("to_#{klass.name.demodulize.underscore}") do
          ### TODO reload?
          becomes(klass)
        end
        
        klass.reflect_on_all_associations.each do |r|
          case r.macro
          when :belongs_to
            ### ensure that the fk column exists
          when :has_many
            ### TODO add options for :through assocs
            options = r.options.merge(
              :class_name => r.class_name,
              :foreign_key => r.primary_key_name
            )
            has_many r.name, options
          when :has_and_belongs_to_many
            options = r.options.merge(
              :class_name => r.class_name,
              :foreign_key => r.primary_key_name,
              :association_foreign_key => r.association_foreign_key
            )
            has_and_belongs_to_many r.name, options
          end
        end
      end
    end
  end
end
