require "set"
require "attentive/tokenizer"

module Attentive
  class Message
    attr_reader :contexts, :text, :original_message

    def initialize(original_message, params={})
      @original_message = original_message
      @text = original_message.to_s
      @contexts = Set.new(params.fetch(:contexts, []))
      @contexts << :conversation if tokens.grep(Attentive::Tokens::Invocation).any?
      @contexts += Array(original_message.contexts) if original_message.respond_to?(:contexts)
    end

    def tokens
      @tokens ||= Attentive::Tokenizer.tokenize(text)
    end

    def [](key)
      tokens[key]
    end

    def []=(key, value)
      tokens[key] = value
    end

    def length
      tokens.length
    end

    alias :to_s :text

    def inspect
      tokens.inspect
    end

  end
end
