require "attentive/abbreviations"
require "attentive/contractions"
require "attentive/text"
require "attentive/tokens"
require "attentive/phrase"
require "attentive/errors"


module Attentive
  class Tokenizer
    extend Attentive::Tokens

    # Splits apart words and punctuation,
    # treats apostrophes and dashes as a word-characters,
    # trims each fragment of whitepsace
    # SPLITTER = /\s*([\w'-]+)\s*/.freeze
    SPLITTER = /(\n|{{|}}|\s+|\.{2,}|[^\s\w'@-])/.freeze
    PUNCTUATION = /^\W+$/.freeze
    WHITESPACE = /^\s+$/.freeze
    ENTITY_START = "{{".freeze
    ENTITY_END = "}}".freeze
    REGEXP_START = "(".freeze
    REGEXP_END = ")".freeze
    REGEXP_ESCAPE = "\\".freeze


    def self.split(message)
      Attentive::Text.normalize(message).split(SPLITTER).reject(&:empty?)
    end


    def self.tokenize(message, options={})
      match_entities = options.fetch(:entities, false)
      match_regexps = options.fetch(:regexps, false)
      fail_if_ambiguous = !options.fetch(:ambiguous, true)
      strings = split(message)
      tokens = []
      i = 0
      pos = 0
      while i < strings.length
        string = strings[i]
        case string
        when ""
          # do nothing

        when WHITESPACE
          tokens << whitespace(string, pos: pos)

        when ":"
          if strings[i + 2] == ":"
            tokens << emoji(strings[i + 1], pos: pos)
            pos += strings[i + 1].length + 1
            i += 2
          else
            tokens << punctuation(":", pos: pos)
          end

        when ENTITY_START
          if match_entities
            j = i + 1
            found_entity = false
            while j < strings.length
              if strings[j] == ENTITY_END
                entity = strings[(i + 1)...j] # e.g. ["variable-name", ":" "entity-type"]
                tokens << entity(*entity.join.split(":").reverse, pos: pos)
                i = j + 1
                pos += entity.join.length + 4
                found_entity = true
                break
              end
              j += 1
            end
            next if found_entity
          end
          tokens << punctuation(ENTITY_START, pos: pos)

        when REGEXP_START
          if match_regexps && strings[i + 1] == "?"
            j = i + 2
            found_regexp = false
            parens = 1
            inside_square_bracket = false
            while j < strings.length
              if strings[j] == "[" && strings[j - 1] != REGEXP_ESCAPE
                inside_square_bracket = true
              elsif strings[j] == "]" && strings[j - 1] != REGEXP_ESCAPE
                inside_square_bracket = false
              end

              unless inside_square_bracket
                if strings[j] == REGEXP_START && strings[j - 1] != REGEXP_ESCAPE
                  parens += 1
                elsif strings[j] == REGEXP_END && strings[j - 1] != REGEXP_ESCAPE
                  parens -= 1
                end

                if parens == 0
                  tokens << regexp(strings[i..j].join, pos: pos)
                  pos += strings[i..j].join.length + 2
                  i = j + 1
                  found_regexp = true
                  break
                end
              end
              j += 1
            end
            next if found_regexp
          end
          tokens << punctuation(REGEXP_START, pos: pos)

        when PUNCTUATION
          tokens << punctuation(string, pos: pos)

        when *Attentive.invocations
          tokens << invocation(string, pos: pos)

        else
          if replace_with = Attentive::ABBREVIATIONS[string]
            tokens.concat tokenize(replace_with, options)

          elsif expands_to = Attentive::CONTRACTIONS[string]
            possibilities = expands_to.map do |possibility|
              tokenize(possibility, options)
            end

            if possibilities.length == 1
              tokens.concat possibilities[0]
            else
              tokens << any_of(possibilities, pos: pos)
            end
          else
            tokens << word(string, pos: pos)
          end
        end

        i += 1
        pos += string.length
      end

      fail_if_ambiguous!(message, tokens) if fail_if_ambiguous

      Attentive::Phrase.new(tokens)
    end

    def self.fail_if_ambiguous!(phrase, tokens)
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
