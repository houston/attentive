require "test_helper"

class AbstracterTest < Minitest::Test
  EXAMPLES = {
    "what's for lunch tomorrow?" => "what's for lunch {{core.date}}?",
    "what time on Wednesday?" => "what time on {{core.date}}?",
    "where were you last Friday?" => "where were you {{core.date}}?",
    "April showers bring May flowers" => "{{core.date.month}} showers bring {{core.date.month}} flowers",
    "16 ounces" => "{{core.number}} ounces",
    "send a reminder to james@example.com" => "send a reminder to {{core.email}}"
  }.freeze


  context "Attentive.abstract" do
    EXAMPLES.each do |message, abstraction|
      should "recognize entities in #{message.inspect}" do
        assert_equal abstraction, Attentive.abstract(message)
      end
    end
  end


end
