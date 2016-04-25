require "attentive/entity"

module Attentive
  class CompositeEntity < Entity
    attr_reader :entities

    @entities = []
    class << self
      attr_accessor :entities

      def define(entity_name, *entities)
        entity_klass = Class.new(Attentive::CompositeEntity)
        entity_klass.token_name = entity_name
        entity_klass.entities = entities.map { |entity| Entity[entity] }
        Entity.register! entity_name, entity_klass
      end
    end

    def initialize(*args)
      super
      @entities = self.class.entities.map { |entity_klass| entity_klass.new(variable_name) }
    end

    def matches?(cursor)
      entities.each do |entity|
        match = entity.matches?(cursor.dup)
        return match if match
      end
      false
    end

  end
end
