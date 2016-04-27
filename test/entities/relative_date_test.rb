require "test_helper"

class RelativeDateTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}

  context "The :relative-date entity" do
    setup do
      Timecop.freeze Date.new(2016, 4, 25)
    end

    teardown do
      Timecop.return
    end

    should "match weekdays" do
      listen_for "what is showing on {{date:relative-date}}"
      hear "what is showing on tuesday"
      assert_matched
      assert_equal Date.new(2016, 4, 26), match["date"]
    end

    should "match abbreviated weekdays" do
      listen_for "what is showing on {{date:relative-date}}"
      hear "what is showing on tues"
      assert_matched
      assert_equal Date.new(2016, 4, 26), match["date"]
    end

    should "match today" do
      listen_for "what is showing {{date:relative-date}}"
      hear "what is showing today"
      assert_matched
      assert_equal Date.new(2016, 4, 25), match["date"]
    end

    should "match yesterday" do
      listen_for "what is showing {{date:relative-date}}"
      hear "what is showing yesterday"
      assert_matched
      assert_equal Date.new(2016, 4, 24), match["date"]
    end

    should "match tomorrow" do
      listen_for "what is showing {{date:relative-date}}"
      hear "what is showing tomorrow"
      assert_matched
      assert_equal Date.new(2016, 4, 26), match["date"]
    end

    should "match weekdays in next week" do
      listen_for "what is showing on {{date:relative-date}}"
      hear "what is showing on next friday"
      assert_matched
      assert_equal Date.new(2016, 5, 6), match["date"]
    end

    should "match weekdays in last week" do
      listen_for "what was showing on {{date:relative-date}}"
      hear "what was showing on last friday"
      assert_matched
      assert_equal Date.new(2016, 4, 22), match["date"]
    end

    should "match in the middle of a phrase" do
      listen_for "is {{date:relative-date}} a casual day"
      hear "is next thursday a casual day"
      assert_matched
      assert_equal Date.new(2016, 5, 5), match["date"]
    end
  end

end
