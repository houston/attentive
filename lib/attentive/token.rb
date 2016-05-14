module Attentive
  class Token
    attr_reader :pos

    def initialize(pos=nil)
      @pos = pos
    end

    def ==(other)
      self.class == other.class
    end

    def ambiguous?
      false
    end

    def entity?
      false
    end

    def whitespace?
      false
    end

    def skippable?
      false
    end

    def eof?
      false
    end

    def matches?(cursor)
      self == cursor.peek
    end

    def inspect
      "<#{self.class.name ? self.class.name.split("::").last : "Entity"} #{to_s.inspect}>"
    end

  end



  class StringToken < Token
    attr_reader :string

    def initialize(string, pos=nil)
      @string = string
      super pos
    end

    def to_str
      to_s
    end

    def to_s
      string
    end

    def length
      string.length
    end

    def ==(other)
      self.class == other.class && self.string == other.string
    end

  end
end
