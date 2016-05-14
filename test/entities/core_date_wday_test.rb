require "test_helper"

class CoreDateWdayTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}


  context "core.date.wday" do
    should "match weekday names" do
      assert_entity_matches "Sunday", as: 0, entity: "core.date.wday"
      assert_entity_matches "Monday", as: 1, entity: "core.date.wday"
      assert_entity_matches "Tuesday", as: 2, entity: "core.date.wday"
      assert_entity_matches "Wednesday", as: 3, entity: "core.date.wday"
      assert_entity_matches "Thursday", as: 4, entity: "core.date.wday"
      assert_entity_matches "Friday", as: 5, entity: "core.date.wday"
      assert_entity_matches "Saturday", as: 6, entity: "core.date.wday"
    end

    should "match weekday abbreviations" do
      assert_entity_matches "sun", as: 0, entity: "core.date.wday"
      assert_entity_matches "mon", as: 1, entity: "core.date.wday"
      assert_entity_matches "tue", as: 2, entity: "core.date.wday"
      assert_entity_matches "tues", as: 2, entity: "core.date.wday"
      assert_entity_matches "wed", as: 3, entity: "core.date.wday"
      assert_entity_matches "thu", as: 4, entity: "core.date.wday"
      assert_entity_matches "thur", as: 4, entity: "core.date.wday"
      assert_entity_matches "thurs", as: 4, entity: "core.date.wday"
      assert_entity_matches "fri", as: 5, entity: "core.date.wday"
      assert_entity_matches "sat", as: 6, entity: "core.date.wday"
    end

    should "not match things that aren't weekday names" do
      refute_entity_matches "tomorrow", entity: "core.date.wday"
    end
  end


end
