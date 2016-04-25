require "test_helper"

class PunctuationTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}

  context "A listener that expects a punctuation mark" do
    setup do
      listen_for "hello, world"
    end

    should "match messages that use the same punctuation mark" do
      hear "hello, world"
      assert_matched
    end

    should "not messages that don't" do
      hear "hello world"
      refute_matched
    end

    should "match message when the punctuation mark and whitespace are transposed" do
      hear "hello ,world"
      assert_matched
    end
  end

  context "A listener that doesn't expect a punctuation mark" do
    setup do
      listen_for "hello world"
    end

    should "match messages that use gratuitous punctuation" do
      hear "hello, world"
      assert_matched
    end
  end

end
