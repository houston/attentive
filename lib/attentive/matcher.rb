require "attentive/match"

module Attentive
  class Matcher
    attr_reader :phrase, :cursor, :pos

    def initialize(phrase, cursor, params={})
      @phrase = phrase
      @cursor = cursor
      @pos = params.fetch(:pos, 0)
      @match_params = params.each_with_object({}) { |(key, value), new_hash| new_hash[key] = value if %i{listener message}.member?(key) }
      @pos += 1 while phrase[pos] && phrase[pos].whitespace?
      @match_data = {}
      @state = :matching
    end

    def matching?
      @state == :matching
    end

    def mismatch?
      @state == :mismatch
    end

    def match!
      while token = cursor.peek
        if token.ambiguous?
          unless match_subphrase!(token.possibilities)
            @state = :mismatch
            break
          end
          @pos += 1 while phrase[pos] && phrase[pos].whitespace?

        elsif match_data = phrase[pos].matches?(cursor)
          if match_data.is_a?(MatchData)
            new_character_index = cursor.offset + match_data.to_s.length
            @match_data.merge! Hash[match_data.names.zip(match_data.captures)]

            # Advance the cursor to the first token after the regexp match
            cursor_pos = cursor.tokens.index { |token| token.pos >= new_character_index }
            cursor_pos = cursor.tokens.length unless cursor_pos
            cursor.instance_variable_set :@pos, cursor_pos
            @pos += 1
          else
            @match_data.merge!(match_data) unless match_data == true
            @pos += 1
          end
          @pos += 1 while phrase[pos] && phrase[pos].whitespace?
          @state = :found


          # -> This is the one spot where we instantiate a Match
          return Attentive::Match.new(phrase, @match_params.merge(match_data: @match_data)) if pos == phrase.length

        elsif !token.skippable?
          @state = :mismatch
          break
        end

        cursor.pop
        break unless cursor.peek
        while cursor.peek.whitespace?
          cursor.pop
          break unless cursor.peek
        end
      end

      nil
    end

    def match_subphrase!(subphrases)
      subphrases.each do |subphrase|
        matcher = Matcher.new(phrase, Cursor.new(subphrase), pos: pos)
        matcher.match!
        unless matcher.mismatch?
          @pos = matcher.pos
          return true
        end
      end

      false
    end

  end
end
