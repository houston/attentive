module Attentive
  module Config

    attr_reader :me

    def me=(value)
      value = "@#{value}" unless value.start_with?("@")
      raise ArgumentError, "Attentive.me must be a single word and must start with a @. You passed #{value.inspect}" unless value =~ /\A@[\w\-]+\Z/
      @me = value
    end

  end
end
