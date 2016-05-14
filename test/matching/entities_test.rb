require "test_helper"

class EntitiesTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}


  context "A listener that expects an entity in the middle of a phrase" do
    setup do
      listen_for "is {{core.date.relative}} a casual day"
    end

    should "match" do
      hear "is next thursday a casual day"
      assert_matched
    end
  end


  context "A listener that expects an entity that beginning of a phrase" do
    setup do
      listen_for "{{core.date.relative}}, remind me to wear jeans"
    end

    should "match" do
      hear "tomorrow, remind me to wear jeans"
      assert_matched
    end
  end

end
