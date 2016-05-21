module Attentive
  class Trie
    attr_reader :depth

    def initialize(depth: 0)
      @depth = depth
      @children = {}
    end

    def [](token)
      @children[token]
    end

    def add(token)
      raise "Can't add #{token.inspect} to trie because this leaf is a terminus" if fin?
      @children[token] ||= self.class.new(depth: depth + 1)
    end

    def fin?
      @children.key?(:fin)
    end

    def fin
      @children[:fin]
    end

    def fin!(finish)
      @children[:fin] = finish
    end



    def self.of_substitutions(substitutions)
      substitutions.each_with_object(self.new) do |(tokens, substitution), trie|
        leaf = trie
        tokens.each_with_index do |token, i|
          raise "#{tokens.join} contains #{tokens[0...i].join}" if leaf.fin?
          leaf = leaf.add token
        end
        leaf.fin! substitution
      end
    end

  end
end
