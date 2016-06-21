require "attentive/tokens"
require "attentive/phrase"
require "attentive/errors"


module Attentive
  class Tokenizer
    include Attentive::Tokens

    attr_reader :message, :chars, :options

    def self.tokenize(message, options={})
      self.new(message, options).tokenize
    end



    def initialize(message, options={})
      @message = message.downcase
      @chars = self.message.each_char.to_a
      @options = options
    end

    def match_entities?
      options.fetch(:entities, false)
    end

    def match_regexps?
      options.fetch(:regexps, false)
    end

    def perform_substitutions?
      options.fetch(:substitutions, true)
    end

    def fail_if_ambiguous?
      !options.fetch(:ambiguous, true)
    end



    def tokenize
      i = 0
      @tokens = []
      @leaves = []

      while i < chars.length
        char = chars[i]
        char = CHARACTER_SUBSTITIONS.fetch(char, char)
        pos = tokens.any? ? tokens.last.end : 0

        if WHITESPACE === char && string = match_whitespace_at(i)
          add_token whitespace(string, pos: pos)
          i += string.length

        elsif ENTITY_START === char && string = match_entity_at(i)
          add_token entity(string, pos: pos)
          i += string.length + 4

        elsif NUMBER_START === char && string = match_number_at(i)
          add_token word(string, pos: pos)
          i += string.length

        elsif EMOJI_START === char && string = match_emoji_at(i)
          add_token emoji(string, pos: pos)
          i += string.length + 2

        elsif REGEXP_START === char && string = match_regexp_at(i)
          add_token regexp(string, pos: pos)
          i += string.length

        elsif PUNCTUATION === char
          add_token punctuation(char, pos: pos)
          i += 1

        else string = match_word_at(i)
          add_token word(string, pos: pos)
          i += string.length

        end
      end

      fail_if_ambiguous!(message, tokens) if fail_if_ambiguous?

      Attentive::Phrase.new(tokens)
    end



  private
    attr_reader :tokens

    def match_emoji_at(i)
      emoji = ""
      while (i += 1) < chars.length
        return if_present?(emoji) if EMOJI_END === chars[i]
        return false if WHITESPACE === chars[i]
        emoji << chars[i]
      end
      false
    end

    def match_entity_at(i)
      return false unless match_entities?
      return false unless chars[i += 1] == "{"
      entity = ""
      while (i += 1) < chars.length
        return if_present?(entity) if ["}", "}"] == chars[i, 2]
        return false unless ENTITY === chars[i]
        entity << chars[i]
      end
      false
    end

    def match_regexp_at(i)
      return false unless match_regexps?
      return false unless chars[i += 1] == "?"
      regexp = "(?"
      parens = 1
      inside_square_bracket = false
      while (i += 1) < chars.length
        regexp << chars[i]
        next if chars[i - 1] == "\\"
        inside_square_bracket = true if chars[i] == "["
        inside_square_bracket = false if chars[i] == "]"
        next if inside_square_bracket
        parens += 1 if chars[i] == "("
        parens -= 1 if chars[i] == ")"
        return if_present?(regexp) if parens == 0
      end
      false
    end

    def match_whitespace_at(i)
      whitespace = chars[i].dup
      while (i += 1) < chars.length
        break unless WHITESPACE === chars[i]
        whitespace << chars[i]
      end
      whitespace
    end

    def match_number_at(i)
      return false if CONDITIONAL_NUMBER_START === chars[i] && !(NUMBER === chars[i + 1])
      number = chars[i].dup
      while (i += 1) < chars.length
        break unless NUMBER === chars[i] || (CONDITIONAL_NUMBER === chars[i] && NUMBER === chars[i + 1])
        number << chars[i]
      end
      number
    end

    def match_word_at(i)
      word = chars[i].dup
      while (i += 1) < chars.length
        break unless WORD === chars[i]
        word << chars[i]
      end
      word
    end

    def if_present?(string)
      string.empty? ? false : string
    end



    def add_token(token)
      @tokens << token
      return unless perform_substitutions?
      @leaves = add_token_to_leaves token, @leaves
    end

    def add_token_to_leaves(token, leaves)
      (leaves + [Attentive.substitutions]).each_with_object([]) do |leaf, new_leaves|
        if new_leaf = leaf[token]
          if new_leaf.fin?
            i = -1 - leaf.depth
            offset = tokens[i].begin
            replacement = new_leaf.fin.dup.each { |token| token.begin += offset }
            tokens[i..-1] = replacement
            return add_token_to_leaves replacement.last, []
          else
            new_leaves.push new_leaf
          end
        end
      end
    end



    WHITESPACE = /\s/.freeze
    PUNCTUATION = /[^\sa-z0-9_]/.freeze
    EMOJI_START = ":".freeze
    EMOJI_END = ":".freeze
    ENTITY_START = "{".freeze
    ENTITY = /[a-z0-9\.\-:]/.freeze
    REGEXP_START = "(".freeze
    NUMBER_START = /[\d\.\-]/.freeze
    CONDITIONAL_NUMBER_START = /[\.\-]/.freeze
    NUMBER = /\d/.freeze
    CONDITIONAL_NUMBER = /[\.,]/.freeze
    WORD = /[a-z0-9_]/.freeze
    CHARACTER_SUBSTITIONS = {
      "“" => "\"",
      "”" => "\"",
      "‘" => "'",
      "’" => "'" }.freeze

    def fail_if_ambiguous!(phrase, tokens)
      ambiguous_token = tokens.find(&:ambiguous?)
      return unless ambiguous_token

      raise Attentive::AmbiguousPhraseError.new(
        "The phrase #{phrase.inspect} is ambiguous. " <<
        "Please use #{ambiguous_token.possibilities.map(&:inspect).join(" or ")}")
    end

  end
end

# Not the perfect place for these...
# Attentive::Tokenizer needs to be defined first...
require "attentive/entity"
require "attentive/composite_entity"
require "attentive/substitutions"

require "attentive/entities/core"
