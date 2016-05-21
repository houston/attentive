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
      map(&:inspect).join("\n")
    end

    def dup
      self.class.new map(&:dup)
    end

  end
end
