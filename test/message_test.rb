require "test_helper"
require "set"

class MessageTest < Minitest::Test

  context "A message" do
    should "have no contexts by default" do
      message = Attentive::Message.new("hi")
      assert_equal Set[], message.contexts
    end

    should "keep a reference to its first argument" do
      object = Object.new
      stub(object).to_s { "text" }
      message = Attentive::Message.new(object)
      assert_equal "text", message.text
      assert_equal object, message.original_message
    end
  end

  context "When a message contains a mention of the bot, it" do
    should "automatically include the context \"conversation\"" do
      message = Attentive::Message.new("hi @me")
      assert_equal Set[:conversation], message.contexts
    end
  end

end
