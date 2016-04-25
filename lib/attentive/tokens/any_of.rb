require "attentive/token"

module Attentive
  module Tokens
    class AnyOf < Token
      attr_reader :possibilities

      def initialize(possibilities, pos)
        @possibilities = possibilities
        super pos
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
