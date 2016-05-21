require "attentive/trie"

module Attentive
  module Config

    attr_reader :invocations
    attr_accessor :default_required_contexts
    attr_accessor :default_prohibited_contexts

    def invocations=(*values)
      remove_instance_variable :@substitutions if defined?(@substitutions)
      @invocations = values.flatten
    end

    def substitutions
      return @substitutions if defined?(@substitutions)
      @substitutions = Attentive::Trie.of_substitutions(
        Attentive::SUBSTITUTIONS.merge(
          invocations.each_with_object({}) { |invocation, hash|
            tokens = Attentive.tokenize(invocation, substitutions: false)
            hash[tokens] = [Attentive::Tokens::Invocation.new(invocation, 0)]
          } ) )
    end

  end
end
