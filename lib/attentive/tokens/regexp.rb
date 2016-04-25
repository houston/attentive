require "attentive/token"

module Attentive
  module Tokens
    class Regexp < Token
      attr_reader :regexp

      def initialize(string, pos)
        @regexp = ::Regexp.compile("^#{string}")
        super pos
      end

      def ==(other)
        self.class == other.class && self.regexp == other.regexp
      end

      def matches?(cursor)
        regexp.match(cursor.to_s)
      end

      def to_s
        regexp.inspect[1...-1]
      end

    end
  end
end
