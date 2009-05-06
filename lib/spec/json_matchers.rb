
#require 'json' ### blows up with Rails 2.3.2
require 'pp'

module Spec #:nodoc:
  module JSONMatchers
    class BeJsonEql
      def initialize(expected)
        @raw_expected = expected
        @expected = decode(expected, 'expected')
      end

      def matches?(target)
        @raw_target = target
        @target = decode(target, 'target') rescue nil
        @target == @expected
      end

      def failure_message
        actual = @target ? pretty(@target) : @raw_target
        "expected\n#{actual}\nto be JSON code equivalent to\n#{@raw_expected}\n" +
        "Difference:\n#{pretty(@expected.diff(@target))}"
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

      def pretty(obj)
        #JSON.pretty_generate(obj)
        capture_stdout { pp obj }
      end

      def capture_stdout
        oldout = $stdout
        $stdout = StringIO.new
        yield
        $stdout.rewind
        $stdout.read
      ensure
        $stdout = oldout
      end
    end

    def be_json_eql(expected)
      BeJsonEql.new(expected)
    end
  end
end
