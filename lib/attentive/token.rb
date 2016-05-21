module Attentive
  class Token
    attr_accessor :begin

    def initialize(pos=nil)
      @begin = pos
    end

    def end
      self.begin + to_s.length
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
      if self == cursor.peek
        cursor.pop
        return true
      end

      false
    end

    def inspect
      "<#{self.class.name ? self.class.name.split("::").last : "Entity"} #{to_s.inspect}#{" #{self.begin}" if self.begin}>"
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

    def eql?(other)
      self == other
    end

    def hash
      [ self.class, string ].hash
    end

  end
end
