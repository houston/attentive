require "attentive/token"

module Attentive
  module Tokens
    class Invocation < StringToken

      # All invocations are equal
      def ==(other)
        self.class == other.class
      end

      def skippable?
        true
      end

    end
  end
end
