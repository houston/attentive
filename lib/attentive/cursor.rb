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
      peek.tap do
        advance
      end
    end

    def new_from_here
      self.class.new(tokens[pos..-1])
    end

    def to_s
      tokens[pos..-1].join
    end

    def offset
      peek.pos
    end

    def advance(n=1)
      @pos += n
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
