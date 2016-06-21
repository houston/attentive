require "attentive/tokenizer"
require "attentive/errors"

module Attentive
  class Entity < Token
    attr_reader :variable_name


    @entities = {}
    class << self
      attr_accessor :phrases
      attr_accessor :token_name
      attr_writer :published

      def published?
        @published
      end

      def entities
        @entities.values.select(&:published?)
      end

      def [](entity_name)
        entity_name = entity_name.to_sym
        @entities.fetch(entity_name)
      rescue KeyError
        raise Attentive::UndefinedEntityError.new("Undefined Entity #{entity_name.inspect}")
      end

      def define(entity_name, *phrases, &block)
        options = phrases.last.is_a?(::Hash) ? phrases.pop : {}

        create! entity_name do |entity_klass|
          entity_klass.phrases = phrases.map do |phrase|
            Attentive::Tokenizer.tokenize(phrase, entities: true, regexps: true)
          end
          entity_klass.published = options.fetch(:published, true)
          entity_klass.send :define_method, :_value_from_match, &block if block_given?
        end
      end

      def undefine(entity_name)
        entity_symbol = entity_name.to_sym
        unregister! entity_symbol
      end

    protected

      def create!(entity_name)
        entity_symbol = entity_name.to_sym
        entity_klass = Class.new(self)
        entity_klass.token_name = entity_symbol
        yield entity_klass
        Entity.register! entity_symbol, entity_klass
      end

      def register!(entity_name, entity_klass)
        raise ArgumentError, "Entity #{entity_name.inspect} has already been defined" if @entities.key?(entity_name)
        @entities[entity_name] = entity_klass
      end

      def unregister!(entity_name)
        @entities.delete entity_name
      end
    end




    def initialize(variable_name=self.class.token_name, pos=0)
      @variable_name = variable_name.to_s
      super pos
    end

    def name
      self.class.token_name
    end

    def ==(other)
      self.class == other.class && self.variable_name == other.variable_name
    end

    def to_s
      if variable_name.to_s == self.class.token_name.to_s
        "{{#{self.class.token_name}}}"
      else
        "{{#{variable_name}:#{self.class.token_name}}}"
      end
    end

    def entity?
      true
    end

    def matches?(cursor)
      self.class.phrases.each do |phrase|
        catch NOMATCH do
          cursor_copy = cursor.new_from_here
          match = Attentive::Matcher.new(phrase, cursor_copy).match!
          if match
            value = _value_from_match(match) # <-- might throw
            cursor.advance cursor_copy.pos
            return { variable_name => value }
          end
        end
      end
      false
    end

    def _value_from_match(match)
      match.to_s
    end

    def nomatch!
      throw NOMATCH
    end

    NOMATCH = :nomatch.freeze

  end
end
