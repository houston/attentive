require "attentive/token"

module Attentive
  module Tokens
    class Regexp < Token
      attr_reader :regexp

      def initialize(string, pos)
        @regexp = ::Regexp.compile("^#{string}")
        super pos
      end

      def ==(other)
        self.class == other.class && self.regexp == other.regexp
      end

      def matches?(cursor)
        match_data = regexp.match(cursor.to_s)
        return false unless match_data

        # Advance the cursor to the first token after the regexp match
        new_character_index = cursor.offset + match_data.to_s.length
        cursor_pos = cursor.tokens.index { |token| token.pos >= new_character_index }
        cursor_pos = cursor.tokens.length unless cursor_pos
        cursor.advance cursor_pos - cursor.pos

        Hash[match_data.names.zip(match_data.captures)]
      end

      def to_s
        regexp.inspect
      end

    end
  end
end
