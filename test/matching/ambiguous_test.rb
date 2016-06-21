require "test_helper"

class AmbiguousTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}

  context "A listener that uses an ambiguous contraction" do
    setup do
      listen_for "it's complicated"
    end

    should "match messages that expand that contraction any which way" do
      hear "it is complicated"
      assert_matched

      hear "it has complicated"
      assert_matched
    end
  end

end
