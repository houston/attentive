require "test_helper"

class IntegerTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}

  context "The :integer entity" do
    should "match integers" do
      listen_for "what is {{x:integer}} + {{y:integer}}?"
      hear "what is 4 + 5?"
      assert_matched
      assert_equal 4, match[:x]
      assert_equal 5, match[:y]
    end
  end

end
