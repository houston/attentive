require "attentive/match"

module Attentive
  class Matcher
    attr_reader :phrase, :message, :cursor

    def initialize(phrase, message, params={})
      @phrase = phrase
      @match_start = message.pos
      @cursor = Cursor.new(phrase, params.fetch(:pos, 0))
      @message = message
      self.message.pop while self.message.peek.whitespace?
      @match_params = params.merge(message: message.message, match_start: message.pos)
      @match_data = {}
      @state = :matching

      cursor.pop while cursor.peek.whitespace?
    end

    def pos
      cursor.pos
    end

    def matching?
      @state == :matching
    end

    def mismatch?
      @state == :mismatch
    end

    def match!
      until (token = message.peek).eof?
        if token.ambiguous?
          unless match_any!(token.possibilities)
            @state = :mismatch
            break
          end
          message.pop
          cursor.pop while cursor.peek.whitespace?

        elsif match_data = cursor.peek.matches?(message)
          @match_data.merge!(match_data) unless match_data == true
          cursor.pop
          cursor.pop while cursor.peek.whitespace?
          @state = :found

          # -> This is the one spot where we instantiate a Match
          return Attentive::Match.new(phrase, @match_params.merge(
            match_end: message.pos,
            match_data: @match_data)) if cursor.eof?

        elsif token.skippable?
          message.pop

        else
          @state = :mismatch
          break
        end

        message.pop while message.peek.whitespace?
      end

      nil
    end

    def match_any!(messages)
      messages.each do |message|
        matcher = Matcher.new(phrase[pos..-1], Cursor.new(message))
        matcher.match!
        unless matcher.mismatch?
          cursor.advance matcher.pos
          return true
        end
      end

      false
    end

  end
end
