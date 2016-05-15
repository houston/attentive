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
