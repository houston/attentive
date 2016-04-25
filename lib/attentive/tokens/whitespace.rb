require "attentive/token"

module Attentive
  module Tokens
    class Whitespace < StringToken

      # All whitespace is equal
      def ==(other)
        self.class == other.class
      end

      def skippable?
        true
      end

      def whitespace?
        true
      end

    end
  end
end
