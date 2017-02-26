require "attentive"
require "attentive/cursor"
require "attentive/listener"
require "attentive/matcher"
require "concurrent/array"
require "delegate"

module Attentive
  class ListenerCollection < SimpleDelegator

    def initialize
      super Concurrent::Array.new
    end

    def listen_for(*args, &block)
      options = args.last.is_a?(::Hash) ? args.pop : {}

      Attentive::Listener.new(self, args, options, block).tap do |listener|
        push listener
      end
    end

    def hear(message)
      message = Attentive::Message.new(message) unless message.is_a?(Attentive::Message)

      listeners = select { |listener| listener.matches_context?(message) }

      # Listen for any known phrase, starting with any token in the message.
      matches = []
      message.tokens.each_with_index do |token, i|
        listeners.each do |listener|
          listener.phrases.each do |phrase|
            match = Attentive::Matcher.new(phrase, Cursor.new(message, i), listener: listener).match!
            next unless match

            # Don't match more than one phrase per listener
            matches.push match
            break
          end
        end
      end
      matches
    end

  end
end
