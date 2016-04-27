require "attentive/version"
require "attentive/config"

module Attentive
  extend Attentive::Config

  # Default configuration
  self.me = "@me".freeze


  # Attentive DSL

  def listeners
    @listeners ||= Attentive::ListenerCollection.new
  end

  def listen_for(*args, &block)
    listeners.listen_for(*args, &block)
  end

  def hear(message, params={})
    message = Attentive::Message.new(message, params) unless message.is_a?(Attentive::Message)
    listeners.hear message
  end

end

require "attentive/listener_collection"
require "attentive/message"
