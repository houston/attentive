require "attentive/entity"

module Attentive
  class CompositeEntity < Entity
    attr_reader :entities

    @entities = []
    class << self
      attr_accessor :entities

      def define(entity_name, *entities)
        options = entities.last.is_a?(::Hash) ? entities.pop : {}

        create! entity_name do |entity_klass|
          entity_klass.entities = entities.map { |entity| Entity[entity] }
          entity_klass.published = options.fetch(:published, true)
        end
      end
    end

    def initialize(*args)
      super
      @entities = self.class.entities.map { |entity_klass| entity_klass.new(variable_name) }
    end

    def matches?(cursor)
      entities.each do |entity|
        match = entity.matches?(cursor)
        return match if match
      end
      false
    end

  end
end
