module Attentive
  module Tokens

    def any_of(possibilities, pos: nil)
      Attentive::Tokens::AnyOf.new possibilities, pos
    end

    def emoji(string, pos: nil)
      Attentive::Tokens::Emoji.new string, pos
    end

    def entity(entity_name, variable_name=entity_name, pos: nil)
      Attentive::Entity[entity_name.to_sym].new(variable_name)
    end

    def invocation(string, pos: nil)
      Attentive::Tokens::Invocation.new string, pos
    end

    def punctuation(string, pos: nil)
      Attentive::Tokens::Punctuation.new string, pos
    end

    def regexp(string, pos: nil)
      Attentive::Tokens::Regexp.new string, pos
    end

    def whitespace(string, pos: nil)
      Attentive::Tokens::Whitespace.new string, pos
    end

    def word(string, pos: nil)
      Attentive::Tokens::Word.new string, pos
    end

  end
end

require "attentive/tokens/any_of"
require "attentive/tokens/emoji"
require "attentive/tokens/invocation"
require "attentive/tokens/punctuation"
require "attentive/tokens/regexp"
require "attentive/tokens/whitespace"
require "attentive/tokens/word"
