require "attentive/tokenizer"
require "set"

module Attentive
  class Listener
    attr_reader :phrases

    def initialize(listeners, phrases, options, callback)
      context_options = options.fetch(:context, {})
      @required_contexts = context_options.fetch(:in, Attentive.default_required_contexts)
      @required_contexts = [] if @required_contexts == :any
      @required_contexts = Set[*@required_contexts]
      @prohibited_contexts = context_options.fetch(:not_in, Attentive.default_prohibited_contexts)
      @prohibited_contexts = Set[*@prohibited_contexts]

      @listeners = listeners
      @phrases = tokenize_phrases!(phrases)
      @callback = callback
    end

    def matches_context?(message)
      return false unless message.contexts.superset? @required_contexts
      return false unless message.contexts.disjoint? @prohibited_contexts
      true
    end

    def stop_listening!
      listeners.delete self
      self
    end

    def call(e)
      @callback.call(e)
    end

  private
    attr_reader :listeners

    def tokenize_phrases!(phrases)
      phrases.map do |phrase|
        tokenize_phrase!(phrase)
      end
    end

    def tokenize_phrase!(phrase)
      Attentive::Tokenizer.tokenize(phrase, entities: true, regexps: true)
    end

  end
end
