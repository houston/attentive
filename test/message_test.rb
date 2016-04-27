require "test_helper"
require "set"

class MessageTest < Minitest::Test

  context "A message" do
    should "have no contexts by default" do
      message = Attentive::Message.new("hi")
      assert_equal Set[], message.contexts
    end
  end

  context "When a message contains a mention of the bot, it" do
    should "automatically include the context \"conversation\"" do
      message = Attentive::Message.new("hi @me")
      assert_equal Set[:conversation], message.contexts
    end
  end

end
