require "test_helper"

class CoreEmailTest < Minitest::Test
  extend Attentive::Test::Entities


  entity("core.email").should do
    match("test@slackbot.com").as("test@slackbot.com")
    match("tom.test@slackbot.com").as("tom.test@slackbot.com")

    ignore("@slackbot")
  end


end
