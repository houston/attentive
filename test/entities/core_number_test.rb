require "test_helper"

class CoreNumberTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}


  context "core.number" do
    should "match zero" do
      assert_entity_matches "0", as: 0, entity: "core.number"
    end

    should "match positive integers" do
      assert_entity_matches "4", as: 4, entity: "core.number"
    end

    should "match negative integers" do
      assert_entity_matches "-5", as: -5, entity: "core.number"
    end

    should "match numbers with decimal points with BigDecimal" do
      assert_entity_matches "6.75", as: BigDecimal.new("6.75"), entity: "core.number"
    end

    should "match numbers with thousands separated by commas" do
      assert_entity_matches "451,972.00", as: BigDecimal.new("451972.00"), entity: "core.number"
    end

    should "ignore units" do
      assert_entity_matches "$6.45", as: BigDecimal.new("6.45"), entity: "core.number"
      assert_entity_matches "12.3%", as: BigDecimal.new("12.3"), entity: "core.number"
      assert_entity_matches "45mm", as: 45, entity: "core.number"
      assert_entity_matches "45'", as: 45, entity: "core.number"
    end
  end


end
