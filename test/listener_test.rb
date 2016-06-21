require "test_helper"

class ListenerTest < Minitest::Test
  include Attentive::Test::Matching

  context "When a listener is defined with an entity that doesn't exist, it" do
    should "raise an exception" do
      assert_raises Attentive::UndefinedEntityError do
        listen_for "show me showtimes for {{movie}}"
      end
    end
  end

  context "When a listener is defined with exactly the same phrase — and context — as another, it" do
    should "raise an exception" do
      skip
    end
  end

end
