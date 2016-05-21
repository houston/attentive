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
        # Compare the original, untokenized, message to the regular expression
        match_data = regexp.match(cursor.to_s)
        return false unless match_data

        # Find the first token following the match
        new_character_index = cursor.offset + match_data.to_s.length
        cursor_pos = cursor.tokens.index { |token| token.begin >= new_character_index }
        cursor_pos = cursor.tokens.length unless cursor_pos

        # If the match ends in the middle of a token, treat it as a mismatch
        match_end_token = cursor.tokens[cursor_pos - 1]
        return false if match_end_token.begin + match_end_token.length > new_character_index

        # Advance the cursor to the first token after the regexp match
        cursor.advance cursor_pos - cursor.pos

        # Return the MatchData as a hash
        Hash[match_data.names.zip(match_data.captures)]
      end

      def to_s
        regexp.inspect
      end

    end
  end
end
