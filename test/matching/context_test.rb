require "test_helper"

class ContextTest < Minitest::Test
  include Attentive::Test::Matching

  context "A default listener" do
    setup do
      listen_for "hello"
    end

    should "match messages that have the context of :conversation" do
      hear "hello", contexts: [:conversation]
      assert_matched
    end

    should "not messages without that context" do
      hear "hello"
      refute_matched
    end
  end

  context "A listener that sets no requirements of context" do
    setup do
      listen_for "hello", context: { in: :any }
    end

    should "match messages that aren't part of a conversation with the listening bot" do
      hear "hello"
      assert_matched
    end
  end

end
