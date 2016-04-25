require "attentive/token"

module Attentive
  module Tokens
    class Me < Token

      def to_s
        Attentive::Tokenizer::ME
      end

      def skippable?
        true
      end

    end
  end
end
