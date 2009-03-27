
module Spec
  module JSONMatchers
    class BeJsonEql
      def initialize(expected)
        @raw_expected = expected
        @expected = decode(expected, 'expected')
      end
      
      def matches?(target)
        @raw_target = target
        @target = decode(target, 'target')
        @target == @expected
      end
      
      def failure_message
        "expected\n#{@raw_target}\nto be JSON code equivalent to\n#{@raw_expected}"
      end
      
      def negative_failure_message
        "expected\n#{@raw_target}\nto be JSON code different from\n#{@raw_expected}"
      end
      
      private
      
      def decode(s, which)
        ActiveSupport::JSON.decode(s)
      rescue ActiveSupport::JSON::ParseError
        raise ArgumentError, "Invalid #{which} JSON string: #{s.inspect}"
      end
    end
  
    def be_json_eql(expected)
      BeJsonEql.new(expected)
    end
  end
end
