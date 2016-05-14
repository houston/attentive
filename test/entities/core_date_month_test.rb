require "test_helper"

class CoreDateMonthTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}


  context "core.date.month" do
    should "match month names" do
      assert_entity_matches "January", as: 1, entity: "core.date.month"
      assert_entity_matches "February", as: 2, entity: "core.date.month"
      assert_entity_matches "March", as: 3, entity: "core.date.month"
      assert_entity_matches "April", as: 4, entity: "core.date.month"
      assert_entity_matches "May", as: 5, entity: "core.date.month"
      assert_entity_matches "June", as: 6, entity: "core.date.month"
      assert_entity_matches "July", as: 7, entity: "core.date.month"
      assert_entity_matches "August", as: 8, entity: "core.date.month"
      assert_entity_matches "September", as: 9, entity: "core.date.month"
      assert_entity_matches "October", as: 10, entity: "core.date.month"
      assert_entity_matches "November", as: 11, entity: "core.date.month"
      assert_entity_matches "December", as: 12, entity: "core.date.month"
    end

    should "match month abbreviations" do
      assert_entity_matches "jan", as: 1, entity: "core.date.month"
      assert_entity_matches "feb", as: 2, entity: "core.date.month"
      assert_entity_matches "mar", as: 3, entity: "core.date.month"
      assert_entity_matches "apr", as: 4, entity: "core.date.month"
      assert_entity_matches "jun", as: 6, entity: "core.date.month"
      assert_entity_matches "jul", as: 7, entity: "core.date.month"
      assert_entity_matches "aug", as: 8, entity: "core.date.month"
      assert_entity_matches "sep", as: 9, entity: "core.date.month"
      assert_entity_matches "sept", as: 9, entity: "core.date.month"
      assert_entity_matches "oct", as: 10, entity: "core.date.month"
      assert_entity_matches "nov", as: 11, entity: "core.date.month"
      assert_entity_matches "dec", as: 12, entity: "core.date.month"
    end

    should "not match things that aren't month names" do
      refute_entity_matches "spring", entity: "core.date.month"
    end

    should "not match month integers" do
      refute_entity_matches "4", entity: "core.date.month"
    end
  end


end
