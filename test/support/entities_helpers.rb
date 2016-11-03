module Attentive
  module Test
    module Entities

      def self.extended(base)
        base.send :include, Attentive::Test::Matching
      end

      def entity(entity_name)
        EntityContext.new(self, entity_name)
      end

      EntityContext = Struct.new(:suite, :entity_name) do
        def should(&block)
          _self = self
          suite.context entity_name do
            _self.instance_eval(&block)
          end
        end

        def match(message)
          EntityMatcher.new(suite, entity_name, message)
        end

        def ignore(message)
          _self = self
          suite.should "not match #{message}" do
            listen_for "{{#{_self.entity_name}}}", context: { in: :any }
            hear message
            refute_matched
          end
        end

        def respond_to_missing?(*args)
          return true if suite.respond_to?(*args)
          super
        end

        def method_missing(method_name, *args, &block)
          return suite.public_send(method_name, *args, &block) if suite.respond_to?(method_name)
          super
        end
      end

      EntityMatcher = Struct.new(:suite, :entity_name, :message) do
        def as(expected_value)
          _self = self
          suite.should "match #{message}" do
            listen_for "{{#{_self.entity_name}}}", context: { in: :any }
            hear _self.message
            assert_matched
            assert_equal expected_value, match[_self.entity_name]
          end
        end
      end

    end
  end
end
