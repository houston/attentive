require "attentive/version"
require "attentive/listener_collection"
require "attentive/message"

module Attentive

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
