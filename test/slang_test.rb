require "test_helper"

class SlangTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}

  context "When a message contains a contraction, it" do
    should "match phrases that don't" do
      listen_for "hello"
      hear "hi"
      assert_matched
    end
  end

  context "When a phrase contains a contraction, it" do
    should "match messages that don't" do
      listen_for "bye"
      hear "goodbye"
      assert_matched
    end
  end

end
