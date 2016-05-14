module Attentive
  module Test
    module Matching
      include Attentive

      attr_reader :match

      def hear(message, params={})
        (params[:contexts] ||= []).concat Array(self.class.default_context)

        @last_message = Attentive::Message.new(message, params)
        @matches = super @last_message
        @match = @matches[0]
      end

      def assert_matched(message=nil)
        flunk "No message was heard" unless @last_message

        return if matched?
        flunk message if message
        flunk "Expected #{@last_message.inspect} to match one of\n" <<
              all_phrases.map { |phrase| "     #{phrase.inspect}\n" }.join
      end

      def refute_matched(message=nil)
        flunk "No message was heard" unless @last_message

        return unless matched?
        flunk message if message
        flunk "Expected #{@last_message.inspect} not to match any listener"
      end

      def assert_entity_matches(message, entity:nil, as:nil)
        raise ArgumentError.new("Missing required argument :entity") unless entity
        listen_for "{{x:#{entity}}}"
        hear message
        assert_matched
        assert_equal as, match[:x] if as
      end

      def refute_entity_matches(message, entity:nil)
        raise ArgumentError.new("Missing required argument :entity") unless entity
        listen_for "{{x:#{entity}}}"
        hear message
        refute_matched
      end

      def matched?
        !match.nil?
      end



      def self.included(base=nil, &block)
        class << base
          @default_context = []
          attr_accessor :default_context
        end
      end


    private

      def all_phrases
        listeners.flat_map(&:phrases)
      end

    end
  end
end
