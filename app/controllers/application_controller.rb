# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  protected

  def self.normalize_references(*associations)
    filter = lambda { |controller|
      normalize_param_references(associations, controller.params)
    }
    before_filter filter, :only => [:create, :update]
  end

  def set_content_range(total, from_item = 0, to_item = total - 1)
    response.headers['Content-Range'] = "items #{from_item}-#{to_item}/#{total}"
  end

  def self.normalize_param_references(associations, params)
    associations.each do |assoc|
      if attributes = params[:attributes]
        Array(attributes[assoc]).each do |ref|
          case ref
          when Hash
            ref['id'] = normalize_id(ref.delete('$ref'))
            ref
          when String
            normalize_id(ref)
          else
            ref
          end
        end
      end
    end
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  private

  def self.normalize_id(id_param)
    id_param.sub(%r{^.*/}, '')
  end
end
