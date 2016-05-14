module Attentive
  class Cursor
    attr_reader :tokens, :pos

    def initialize(tokens, pos=0)
      @tokens = tokens
      @pos = pos
    end

    def peek
      tokens[pos] || EOF
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

    def eof?
      @pos == @tokens.length
    end



  private

    class Eof
      def whitespace?
        false
      end

      def eof?
        true
      end
    end
    EOF = Eof.new.freeze

  end
end
