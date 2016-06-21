require "attentive/token"

module Attentive
  module Tokens
    class AnyOf < StringToken
      attr_reader :possibilities

      def initialize(string, possibilities, pos)
        super string, pos
        @possibilities = possibilities
      end

      def ==(other)
        self.class == other.class && self.possibilities == other.possibilities
      end

      def ambiguous?
        true
      end

      def matches?(cursor)
        possibilities.each do |phrase|
          cursor_copy = cursor.new_from_here
          match = Attentive::Matcher.new(phrase, cursor_copy).match!
          if match
            cursor.advance cursor_copy.pos
            return match.to_h
          end
        end
        false
      end

    end
  end
end
