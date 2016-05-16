module Attentive
  class Match
    attr_reader :listener, :phrase, :message

    def initialize(phrase, attributes={})
      @phrase = phrase.to_s
      @match_data = attributes.fetch(:match_data, {})
      @listener = attributes[:listener]
      @message = attributes[:message]
    end

    def matched?(variable_name)
      @match_data.key? variable_name.to_s
    end

    def [](variable_name)
      @match_data.fetch variable_name.to_s
    rescue KeyError
      raise KeyError, "#{$!.message} in #{inspect}"
    end

    def to_s
      @phrase
    end

    def to_h
      @match_data
    end

    def inspect
      "#<#{self.class.name} #{@match_data.inspect} #{phrase.inspect}>"
    end

  end
end
