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
        Array(attributes[assoc]).map! { |value| ParameterNormalizer.normalize(value) }
      end
    end
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

end
