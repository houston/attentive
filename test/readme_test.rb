require "test_helper"

# The examples in the README should work
class ReadmeTest < Minitest::Test
  include Attentive


  context "Hello World" do
    should "work" do
      listen_for "hi", context: { in: :any } do
        puts "nice to meet you!"
      end

      hear! "hi!" # => "nice to meet you!"
      assert_equal "nice to meet you!", output
    end
  end


  context "Optional Characters" do
    should "work" do
      listen_for "hi!", context: { in: :any } do
        puts "nice to meet you!"
      end

      hear! "hi" # => nothing happened, the listener is expecting the exclamation mark
      assert_equal "", output
    end
  end


  context "Contractions and Abbreviations" do
    should "work" do
      listen_for "hi", context: { in: :any } do
        puts "nice to meet you!"
      end

      hear! "hello!" # => "nice to meet you!"
      assert_equal "nice to meet you!", output

      listen_for "what is for lunch", context: { in: :any } do
        puts "HAMBURGERS!"
      end

      hear! "what's for lunch?" # => "HAMBURGERS!"
      assert_equal "HAMBURGERS!", output
    end
  end


  context "Contexts" do
    should "work" do
      listen_for "ouch", context: { in: %i{#general}, not_in: %i{serious} } do
        puts "On a scale of 1 to 10, how would you rate your pain?"
      end

      hear! "ouch" # => message has no context, listener isn't triggered
      assert_equal "", output

      hear! "ouch", contexts: %i{#general} # => "On a scale of 1 to 10..."
      assert_equal "On a scale of 1 to 10, how would you rate your pain?", output

      hear! "ouch", contexts: %i{#general serious} # => listener ignores "serious" messages
      assert_equal "", output
    end
  end


  context "Entities" do
    should "work" do
      Attentive::Entity.define "restaurants.deweys.menu.beers",
        "Bell's Oberon",
        "Rogue Dead Guy Ale",
        "Schalfly Dry Hopped IPA",
        "4 Hands Contact High",
        "Scrimshaw Pilsner"

      listen_for "I will have a pint of the {{restaurants.deweys.menu.beers}}" do
        puts "Good choice"
      end

      hear! "I will have a pint of the Schalfly Dry Hopped IPA", contexts: %i{conversation}
      assert_equal "Good choice", output
    end
  end


private
  attr_reader :output

  def hear!(*args)
    @output = ""
    super
  end

  def puts(output)
    @output << output
  end

end
