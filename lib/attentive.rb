require "attentive/version"
require "attentive/config"


module Attentive
  extend Attentive::Config

  # Default configuration
  self.invocations = ["@me".freeze]

  # Default contexts that listeners will require
  # a message to be heard in.
  self.default_required_contexts = %i{conversation}

  # Default contexts in which listeners will ignore messages.
  self.default_prohibited_contexts = %i{quotation}



  # Recognizes entities in a phrase
  def self.abstract(message)
    message = Attentive::Message.new(message)
    entities = Attentive::Entity.entities.map { |entity| Attentive::Phrase.new([entity.new]) }
    i = 0
    while i < message.tokens.length
      abstractions = entities.each_with_object({}) do |entity, abstractions|
        match = Attentive::Matcher.new(entity, Cursor.new(message, i)).match!
        abstractions[entity[0].name.to_s] = { entity: entity, match: match } if match
      end

      # Pick the most abstract entity: if we match both
      # {{core.date}} and {{core.date.past}}, use {{core.date}}
      if abstractions.any?
        keys = abstractions.keys
        keys.reject! { |key| keys.any? { |other_key| key != other_key && key.start_with?(other_key) } }
        abstraction = abstractions[keys.first]
        i = abstraction[:match].replace_with(abstraction[:entity])
      end

      i += 1
    end
    message.tokens.to_s
  end

  # Shorthand for tokenizer
  def self.tokenize(message, options={})
    Attentive::Tokenizer.tokenize(message, options)
  end



  # Attentive DSL

  def listeners
    @listeners ||= Attentive::ListenerCollection.new
  end

  def listen_for(*args, &block)
    listeners.listen_for(*args, &block)
  end

  # Matches a message against all listeners
  # and returns an array of matches
  def hear(message, params={})
    message = Attentive::Message.new(message, params) unless message.is_a?(Attentive::Message)
    listeners.hear message
  end

  # Matches a message against all listeners
  # and invokes the first listener that mathes
  def hear!(message, params={})
    hear(message, params).each do |match|
      match.listener.call(match)
      return
    end
  end

end

require "attentive/listener_collection"
require "attentive/message"
