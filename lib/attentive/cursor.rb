module Attentive
  class Cursor
    attr_reader :tokens, :pos

    def initialize(tokens, pos=0)
      @tokens = tokens
      @pos = pos
    end

    def peek
      tokens[pos]
    end

    def pop
      @pos += 1
      tokens[pos - 1]
    end

    def to_s
      tokens[pos..-1].join
    end

    def offset
      peek.pos
    end

  end
end
