
require 'spec/mocks/message_expectation'

module Spec #:nodoc:
  module Mocks #:nodoc:

    class ScopeExpectation
      def initialize(model_class, expected_scopes)
        @model_class, @expected_scopes = model_class, expected_scopes
      end
      def scope_matches?
        match = @expected_scopes.all? { |key, scope|
          actual = @model_class.send(:scope, key)
          ok = actual == scope
          $stderr.puts "*** Scope mismatch\nExpected: #{scope.inspect},\nActual: #{actual.inspect}" unless ok
          ok
        }
        match
      end
    end


    module MessageExpectationScopeExtension
      def self.included(base)
        base.send(:alias_method, :matches_without_scope, :matches)
        base.send(:alias_method, :matches, :matches_with_scope)
      end
      def within_scope(*args)
        @scope_expectation = ScopeExpectation.new(*args)
        self
      end
      def matches_with_scope(*args, &block)
        matches_without_scope(*args, &block) &&
          (!@scope_expectation || @scope_expectation.scope_matches?)
      end
    end
  end
end

Spec::Mocks::MessageExpectation.class_eval do
  include Spec::Mocks::MessageExpectationScopeExtension
end
