module Attentive
  class Match
    attr_reader :listener, :phrase, :message, :match_start, :match_end

    def initialize(phrase, attributes={})
      @phrase = phrase.to_s
      @match_data = attributes.fetch(:match_data, {})
      @match_start = attributes.fetch(:match_start)
      @match_end = attributes.fetch(:match_end)
      @message = attributes.fetch(:message)
      @listener = attributes[:listener]
    end

    def matched?(variable_name)
      !@match_data[variable_name.to_s].nil?
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

    def replace_with(tokens)
      message[match_start...match_end] = tokens
      match_start + tokens.length
    end

    def inspect
      "#<#{self.class.name} #{@match_data.inspect} #{phrase.inspect}>"
    end

  end
end
