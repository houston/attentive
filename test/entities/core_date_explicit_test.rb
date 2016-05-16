require "test_helper"

class CoreDateExplicitTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}



  context "core.date.explicit" do
    should "match 2016-04-20" do
      assert_entity_matches "2016-04-20", as: Date.new(2016, 4, 20), entity: "core.date.explicit"
    end

    should "match 4/20/2016" do
      assert_entity_matches "4/20/2016", as: Date.new(2016, 4, 20), entity: "core.date.explicit"
    end

    should "match April 20, 2016" do
      assert_entity_matches "April 20, 2016", as: Date.new(2016, 4, 20), entity: "core.date.explicit"
    end

    should "match Apr 20 2016" do
      assert_entity_matches "Apr 20 2016", as: Date.new(2016, 4, 20), entity: "core.date.explicit"
    end

    should "match 20 April 2016" do
      assert_entity_matches "20 April 2016", as: Date.new(2016, 4, 20), entity: "core.date.explicit"
    end
  end



end
