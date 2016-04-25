require "attentive/token"

module Attentive
  module Tokens
    class Emoji < StringToken

      def to_s
        ":#{string}:"
      end

      def skippable?
        true
      end

    end
  end
end
