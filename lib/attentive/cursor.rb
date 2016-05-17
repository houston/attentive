module Attentive
  class Cursor
    attr_reader :message, :tokens, :pos

    def initialize(message, pos=0)
      @message = message
      @tokens = message.respond_to?(:tokens) ? message.tokens : message
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

    def inspect
      "|#{(tokens[0...pos] || []).join}\e[7m#{tokens[pos]}\e[0m#{(tokens[(pos + 1)..-1] || []).join}|"
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
