require "attentive/text"
require "attentive/tokenizer"
require "set"

module Attentive
  class Listener
    attr_reader :phrases

    def initialize(listeners, args, callback)
      options = args.last.is_a?(::Hash) ? args.pop : {}

      # Ugh!
      context_options = options.fetch(:context, {})
      @required_contexts = context_options.fetch(:in, %i{conversation})
      @required_contexts = [] if @required_contexts == :any
      @required_contexts = Set[*@required_contexts]
      @prohibited_contexts = context_options.fetch(:not_in, %i{quotation})
      @prohibited_contexts = Set[*@prohibited_contexts]

      @listeners = listeners
      @callback = callback
      @phrases = tokenize_phrases!(args)
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
      # should this be {regexps: false}?
      Attentive::Tokenizer.tokenize(phrase, entities: true, regexps: true, ambiguous: false)
    end

  end
end
