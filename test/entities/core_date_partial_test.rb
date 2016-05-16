require "test_helper"

class CoreDatePartialTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}

  def setup
    Timecop.freeze Date.new(2016, 4, 25)
  end

  def teardown
    Timecop.return
  end



  context "core.date.partial.future" do
    should "match 'June 6' as 'June 6, 2016'" do
      assert_entity_matches "June 6", as: Date.new(2016, 6, 6), entity: "core.date.partial.future"
    end

    should "match 'Mar 1' as 'March 1, 2017'" do
      assert_entity_matches "Mar 1", as: Date.new(2017, 3, 1), entity: "core.date.partial.future"
    end

    should "not match 'Feb 29' [2017]" do
      refute_entity_matches "February 29", entity: "core.date.partial.future"
    end

    should "not match impossible dates" do
      refute_entity_matches "April -5", entity: "core.date.partial.future"
      refute_entity_matches "August 40", entity: "core.date.partial.future"
      refute_entity_matches "Unknown 7", entity: "core.date.partial.future"
    end
  end

  context "core.date.partial.past" do
    should "match 'June 6' as 'June 6, 2015'" do
      assert_entity_matches "June 6", as: Date.new(2015, 6, 6), entity: "core.date.partial.past"
    end

    should "match 'Mar 1' as 'March 1, 2016'" do
      assert_entity_matches "Mar 1", as: Date.new(2016, 3, 1), entity: "core.date.partial.past"
    end

    should "match 'Feb 29' [2016]" do
      assert_entity_matches "February 29", as: Date.new(2016, 2, 29), entity: "core.date.partial.past"
    end

    should "not match impossible dates" do
      refute_entity_matches "April -5", entity: "core.date.partial.past"
      refute_entity_matches "August 40", entity: "core.date.partial.past"
      refute_entity_matches "Unknown 7", entity: "core.date.partial.past"
    end
  end



end
