require "set"
require "attentive/tokenizer"

module Attentive
  class Message
    attr_reader :contexts, :text

    def initialize(text, params={})
      raise ArgumentError, "Message cannot be initialized without 'text'" unless text
      @text = text
      @contexts = Set.new(params.fetch(:contexts, []))
      contexts << :conversation if tokens.grep(Attentive::Tokens::Invocation).any?
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
