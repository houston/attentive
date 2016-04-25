require "test_helper"

class EmojiTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}

  context "A listener that expects an emoji" do
    setup do
      listen_for "Give me a :+1:"
    end

    should "match messages that use that emoji" do
      hear "Give me a :+1:"
      assert_matched
    end

    should "not messages without the emoji" do
      hear "Give me a"
      refute_matched
    end
  end

  context "A listener that doesn't expect an emoji" do
    setup do
      listen_for "I am finished!"
    end

    should "match messages that use gratuitous emojis" do
      hear "I am :speak_no_evil: finished!"
      assert_matched
    end
  end

end
