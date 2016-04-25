require "test_helper"

class ContractionsTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}

  context "When a message contains a contraction, it" do
    should "match phrases that don't use the contraction" do
      listen_for "I will not"
      hear "I won't"
      assert_matched
    end
  end

  context "When a listener contains an contraction, it" do
    should "match messages that don't use the contraction" do
      listen_for "I won't"
      hear "I will not"
      assert_matched
    end
  end

  context "When a message contains an ambiguous contraction, it" do
    should "match all the possible longer phrases" do
      listen_for "what is the deal?"
      hear "what's the deal?"
      assert_matched

      listen_for "what does it look like?"
      hear "what's it look like?"
      assert_matched

      listen_for "what has he done?"
      hear "what's he done?"
      assert_matched
    end
  end

end
