require "set"
require "attentive/tokenizer"

module Attentive
  class Message
    attr_reader :contexts, :text

    def initialize(text, params={})
      @text = text
      @contexts = Set.new(params.fetch(:contexts, []))
      contexts << :conversation if tokens.include?(Attentive::Tokens::Me.new)
    end

    def tokens
      @tokens ||= Attentive::Tokenizer.tokenize(text)
    end

    alias :to_s :text

    def inspect
      tokens.inspect
    end

  end
end
