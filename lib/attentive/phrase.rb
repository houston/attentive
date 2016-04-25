require "delegate"

module Attentive
  class Phrase < SimpleDelegator

    def initialize(tokens)
      super tokens
    end

    def to_s
      join
    end

    def inspect
      "\"#{to_s}\""
    end

  end
end
