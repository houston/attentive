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

  context "core.number.positive" do
    should "match zero" do
      assert_entity_matches "0", as: 0, entity: "core.number.positive"
    end

    should "match positive integers" do
      assert_entity_matches "34,811", as: 34811, entity: "core.number.positive"
    end

    should "match positive floating-point numbers" do
      assert_entity_matches "1,348.66", as: BigDecimal.new("1348.66"), entity: "core.number.positive"
    end

    should "not match negative integers" do
      refute_entity_matches "-100", entity: "core.number.positive"
    end

    should "not match negative floating-point numbers" do
      refute_entity_matches "-0.00125", entity: "core.number.positive"
    end
  end

  context "core.number.positive" do
    should "not match positive integers" do
      refute_entity_matches "34,811", entity: "core.number.negative"
    end

    should "not match positive floating-point numbers" do
      refute_entity_matches "1,348.66", entity: "core.number.negative"
    end

    should "match negative integers" do
      assert_entity_matches "-100", as: -100, entity: "core.number.negative"
    end

    should "match negative floating-point numbers" do
      assert_entity_matches "-0.00125", as: BigDecimal.new("-0.00125"), entity: "core.number.negative"
    end
  end



  context "core.number.integer" do
    should "match integers" do
      assert_entity_matches "0", as: 0, entity: "core.number.integer"
      assert_entity_matches "4", as: 4, entity: "core.number.integer"
      assert_entity_matches "-5", as: -5, entity: "core.number.integer"
    end

    should "not match floating-point numbers" do
      refute_entity_matches "0.5", entity: "core.number.integer"
    end
  end

  context "core.number.integer.positive" do
    should "match zero" do
      assert_entity_matches "0", as: 0, entity: "core.number.integer.positive"
    end

    should "match positive integers" do
      assert_entity_matches "4", as: 4, entity: "core.number.integer.positive"
    end

    should "not match negative integers" do
      refute_entity_matches "-5", entity: "core.number.integer.positive"
    end
  end

  context "core.number.integer.negative" do
    should "not match zero" do
      refute_entity_matches "0", entity: "core.number.integer.negative"
    end

    should "not match positive integers" do
      refute_entity_matches "4", entity: "core.number.integer.negative"
    end

    should "match negative integers" do
      assert_entity_matches "-5", as: -5, entity: "core.number.integer.negative"
    end
  end



  context "core.number.float" do
    should "match floating-point numbers" do
      assert_entity_matches "0.5", as: BigDecimal.new("0.5"), entity: "core.number.float"
    end

    should "not match integers" do
      refute_entity_matches "0", entity: "core.number.float"
      refute_entity_matches "4", entity: "core.number.float"
      refute_entity_matches "-5", entity: "core.number.float"
    end
  end

  context "core.number.float.positive" do
    should "match positive floats" do
      assert_entity_matches "4.00", as: BigDecimal.new("4.00"), entity: "core.number.float.positive"
    end

    should "not match negative floats" do
      refute_entity_matches "-5.99", entity: "core.number.float.positive"
    end
  end

  context "core.number.float.negative" do
    should "not match positive floats" do
      refute_entity_matches "4.00", entity: "core.number.float.negative"
    end

    should "match negative floats" do
      assert_entity_matches "-5.99", as: BigDecimal.new("-5.99"), entity: "core.number.float.negative"
    end
  end



end
