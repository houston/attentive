require "attentive/token"

module Attentive
  module Tokens
    class AnyOf < StringToken
      attr_reader :possibilities

      def initialize(string, possibilities, pos)
        super string, pos
        @possibilities = possibilities
      end

      def ==(other)
        self.class == other.class && self.possibilities == other.possibilities
      end

      def ambiguous?
        true
      end

    end
  end
end
