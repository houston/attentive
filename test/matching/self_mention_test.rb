require "test_helper"

class SelfMentionTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}

  context "A listener that expects a @me mention" do
    setup do
      listen_for "hello @me"
    end

    should "match messages that mention the listening bot" do
      hear "hello @me"
      assert_matched
    end

    should "not messages without the mention" do
      hear "hello"
      refute_matched
    end
  end

  context "A listener that doesn't expect a @me mention" do
    setup do
      listen_for "hey what is up"
    end

    should "match messages that gratuitously mention the listening bot" do
      hear "hey @me what is up"
      assert_matched
    end
  end

end
