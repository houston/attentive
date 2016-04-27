module Attentive
  module Config

    attr_reader :invocations

    def invocations=(*values)
      @invocations = values.flatten
    end

  end
end
