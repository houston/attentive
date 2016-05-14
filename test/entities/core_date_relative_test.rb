require "test_helper"

class RelativeDateTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}


  context "core.date.relative" do
    setup do
      Timecop.freeze Date.new(2016, 4, 25)
    end

    teardown do
      Timecop.return
    end

    should "match weekdays" do
      assert_entity_matches "tuesday", as: Date.new(2016, 4, 26), entity: "core.date.relative"
    end

    should "match today" do
      assert_entity_matches "today", as: Date.new(2016, 4, 25), entity: "core.date.relative"
    end

    should "match yesterday" do
      assert_entity_matches "yesterday", as: Date.new(2016, 4, 24), entity: "core.date.relative"
    end

    should "match tomorrow" do
      assert_entity_matches "tomorrow", as: Date.new(2016, 4, 26), entity: "core.date.relative"
    end

    should "match weekdays in next week" do
      assert_entity_matches "next friday", as: Date.new(2016, 5, 6), entity: "core.date.relative"
    end

    should "match weekdays in last week" do
      assert_entity_matches "last friday", as: Date.new(2016, 4, 22), entity: "core.date.relative"
    end
  end

end
