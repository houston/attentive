require "test_helper"

class MatchTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}

  context "It" do
    setup do
      @listener = listen_for "hello world", "goodbye cruel world"
    end

    should "identify the phrase that was matched" do
      hear "hello world"
      assert_matched
      assert_equal "hello world", match.phrase
    end

    should "identify the listener that was matched" do
      hear "hello world"
      assert_matched
      assert_equal @listener, match.listener
    end

    should "identify the message that was matched" do
      message = "hello world"
      hear message
      assert_matched
      assert_equal message.object_id, match.message.text.object_id
    end
  end

end
