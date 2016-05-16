require "attentive/abbreviations"
require "attentive/contractions"
require "attentive/text"
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
      @message = Attentive::Text.normalize(message)
      @chars = self.message.each_char.to_a
      @options = options
    end



    def tokenize
      i = 0
      tokens = []
      while i < chars.length
        char = chars[i]

        if EMOJI_START === char && string = match_emoji_at(i)
          tokens << emoji(string, pos: i)
          i += string.length + 2

        elsif ENTITY_START === char && string = match_entity_at(i)
          tokens << entity(*string.split(":").reverse, pos: i)
          i += string.length + 4

        elsif REGEXP_START === char && string = match_regexp_at(i)
          tokens << regexp(string, pos: i)
          i += string.length

        elsif WHITESPACE === char && string = match_whitespace_at(i)
          tokens << whitespace(string, pos: i)
          i += string.length

        elsif NUMBER_START === char && string = match_number_at(i)
          tokens << word(string, pos: i)
          i += string.length

        elsif PUNCTUATION === char
          tokens << punctuation(char, pos: i)
          i += 1

        else
          string = match_word_at(i)
          if Attentive.invocations.member?(string)
            tokens << invocation(string, pos: i)

          elsif replace_with = Attentive::ABBREVIATIONS[string]
            tokens.concat self.class.tokenize(replace_with, options)

          elsif expands_to = Attentive::CONTRACTIONS[string]
            possibilities = expands_to.map do |possibility|
              self.class.tokenize(possibility, options)
            end

            if possibilities.length == 1
              tokens.concat possibilities[0]
            else
              tokens << any_of(string, possibilities, pos: i)
            end

          else
            tokens << word(string, pos: i)
          end
          i += string.length
        end
      end

      fail_if_ambiguous!(message, tokens) if fail_if_ambiguous?
      Attentive::Phrase.new(tokens)
    end



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
      whitespace = chars[i]
      while (i += 1) < chars.length
        break unless WHITESPACE === chars[i]
        whitespace << chars[i]
      end
      whitespace
    end

    def match_number_at(i)
      return false if CONDITIONAL_NUMBER_START === chars[i] && !(NUMBER === chars[i + 1])
      number = chars[i]
      while (i += 1) < chars.length
        break unless NUMBER === chars[i] || (CONDITIONAL_NUMBER === chars[i] && NUMBER === chars[i + 1])
        number << chars[i]
      end
      number
    end

    def match_word_at(i)
      word = chars[i]
      while (i += 1) < chars.length
        break unless WORD === chars[i]
        word << chars[i]
      end
      word
    end

    def if_present?(string)
      string.empty? ? false : string
    end



    def match_entities?
      options.fetch(:entities, false)
    end

    def match_regexps?
      options.fetch(:regexps, false)
    end

    def fail_if_ambiguous?
      !options.fetch(:ambiguous, true)
    end

    WHITESPACE = /\s/.freeze
    PUNCTUATION = /[^\sa-z0-9'@]/.freeze
    EMOJI_START = ":".freeze
    EMOJI_END = ":".freeze
    ENTITY_START = "{".freeze
    ENTITY = /[a-z0-9\.\-:]/.freeze
    REGEXP_START = "(".freeze
    NUMBER_START = /[\d\.\-]/.freeze
    CONDITIONAL_NUMBER_START = /[\.\-]/.freeze
    NUMBER = /\d/.freeze
    CONDITIONAL_NUMBER = /[\.,]/.freeze
    WORD = /[\w'@]/.freeze

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

require "attentive/entities/core"
