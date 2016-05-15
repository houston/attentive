module Attentive
  module Config

    attr_reader :invocations
    attr_accessor :default_required_contexts
    attr_accessor :default_prohibited_contexts

    def invocations=(*values)
      @invocations = values.flatten
    end

  end
end
