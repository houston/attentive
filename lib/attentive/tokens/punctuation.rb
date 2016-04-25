require "attentive/token"

module Attentive
  module Tokens
    class Punctuation < StringToken

      def skippable?
        true
      end

    end
  end
end
