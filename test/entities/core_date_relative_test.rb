require "test_helper"

class CoreDateRelativeTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}

  def setup
    Timecop.freeze Date.new(2016, 4, 25)
  end

  def teardown
    Timecop.return
  end



  context "core.date.relative" do
    should "match weekdays as the next upcoming weekday" do
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

    should "match weekdays in last week" do
      assert_entity_matches "last friday", as: Date.new(2016, 4, 22), entity: "core.date.relative"
    end

    should "match weekdays in next week" do
      assert_entity_matches "next friday", as: Date.new(2016, 5, 6), entity: "core.date.relative"
    end
  end



  context "core.date.relative.past" do
    should "match weekdays as the most recent weekday" do
      assert_entity_matches "tuesday", as: Date.new(2016, 4, 19), entity: "core.date.relative.past"
      assert_entity_matches "friday", as: Date.new(2016, 4, 22), entity: "core.date.relative.past"
    end

    should "hear 'last Tuesday' the same as it hears just 'Tuesday'" do
      assert_entity_matches "last tuesday", as: Date.new(2016, 4, 19), entity: "core.date.relative.past"
    end

    should "match today" do
      assert_entity_matches "today", as: Date.new(2016, 4, 25), entity: "core.date.relative.past"
    end

    should "match yesterday" do
      assert_entity_matches "yesterday", as: Date.new(2016, 4, 24), entity: "core.date.relative.past"
    end

    should "not match tomorrow" do
      refute_entity_matches "tomorrow", entity: "core.date.relative.past"
    end
  end



  context "core.date.relative.future" do
    should "match weekdays as the next upcoming weekday" do
      assert_entity_matches "sunday", as: Date.new(2016, 5, 1), entity: "core.date.relative.future"
    end

    should "match today" do
      assert_entity_matches "today", as: Date.new(2016, 4, 25), entity: "core.date.relative.future"
    end

    should "not match yesterday" do
      refute_entity_matches "yesterday", entity: "core.date.relative.future"
    end

    should "match tomorrow" do
      assert_entity_matches "tomorrow", as: Date.new(2016, 4, 26), entity: "core.date.relative.future"
    end

    should "weekdays in next week" do
      assert_entity_matches "next friday", as: Date.new(2016, 5, 6), entity: "core.date.relative.future"
    end
  end



end
