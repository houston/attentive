require "attentive/tokenizer"
require "attentive/errors"

module Attentive
  class Entity < Token
    attr_reader :variable_name


    @entities = {}
    class << self
      attr_accessor :phrases
      attr_accessor :token_name

      def [](entity_name)
        @entities.fetch(entity_name)
      rescue KeyError
        raise Attentive::UndefinedEntityError.new("Undefined Entity #{entity_name.inspect}")
      end

      def define(entity_name, *phrases, &block)
        entity_klass = Class.new(Attentive::Entity)
        entity_klass.token_name = entity_name
        entity_klass.phrases = phrases.map do |phrase|
          Attentive::Tokenizer.tokenize(phrase, entities: true, regexps: true, ambiguous: false)
        end
        entity_klass.send :define_method, :_value_from_match, &block
        register! entity_name, entity_klass
      end

      def register!(entity_name, entity_klass)
        # TODO: raise already registered error
        @entities[entity_name] = entity_klass
      end
    end




    def initialize(variable_name, pos=0)
      @variable_name = variable_name.to_s
      super pos
    end

    def ==(other)
      self.class == other.class && self.variable_name == other.variable_name
    end

    def to_s
      "{{#{variable_name}:#{self.class.token_name}}}"
    end

    def entity?
      true
    end

    def matches?(cursor)
      self.class.phrases.each do |phrase|
        cursor_copy = cursor.new_from_here
        match = Attentive::Matcher.new(phrase, cursor_copy).match!
        if match
          cursor.advance cursor_copy.pos
          return { variable_name => _value_from_match(match) }
        end
      end
      false
    end

  end
end
