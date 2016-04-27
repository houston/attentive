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
      @match_data.key?(variable_name)
    end

    def [](variable_name)
      @match_data.fetch(variable_name)
    end

    def to_s
      @phrase
    end

  end
end
