require "test_helper"

class CoreEmailTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}


  context "core.email" do
    should "match email addresses" do
      assert_entity_matches "test@slackbot.com", as: "test@slackbot.com", entity: "core.email"
      assert_entity_matches "tom.test@slackbot.com", as: "tom.test@slackbot.com", entity: "core.email"
    end

    should "not match mentions" do
      refute_entity_matches "@slackbot", entity: "core.email"
    end
  end


end
