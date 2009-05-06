require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'action_controller'
require 'query_scope'

=begin
class ExplicitResourcesController < ActionController::Base
  include QueryScope
  query_scope :resource => 'explicits'
end

class DerivedResourcesController < ActionController::Base
  include QueryScope
  query_scope
end
=end

describe QueryScope do

  it "sets the scope"

  it "uses an explicitly given resource"

  it "derives the resources from the controller name"

end
