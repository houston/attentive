require "thread_safe"
require "delegate"
require "attentive/cursor"
require "attentive/listener"
require "attentive/matcher"

module Attentive
  class ListenerCollection < SimpleDelegator

    def initialize
      super ThreadSafe::Array.new
    end

    def listen_for(*args, &block)
      Listener.new(self, args, block).tap do |listener|
        push listener
      end
    end

    def overhear(*args, &block)
      Listener.new(self, args, block).tap do |listener|
        push listener
      end
    end



    def hear(message)
      listeners = select { |listener| listener.matches_context?(message) }

      # Listen for any known phrase, starting with any token in the message.
      matches = []
      message.tokens.each_with_index do |token, i|
        listeners.each do |listener|
          listener.phrases.each do |phrase|
            match = Attentive::Matcher.new(phrase, Cursor.new(message.tokens, i)).match!
            matches.push match if match
          end
        end
      end
      matches
    end

  end
end
