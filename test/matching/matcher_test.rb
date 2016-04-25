require "test_helper"

class MatcherTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}

  context "A simple matcher" do
    setup do
      listen_for "hello world"
    end

    should "match whole words" do
      hear "hello world"
      assert_matched
    end

    should "match regardless of extra whitespace" do
      hear " hello  world\n"
      assert_matched
    end

    should "match regardless of gratuitous punctuation" do
      hear "hello world!"
      assert_matched
    end

    should "match regardless of case" do
      hear "Hello World"
      assert_matched
    end

    should "match partial phrases" do
      hear "Hey! hello world, I'm alive!"
      assert_matched
    end

    should "match phrases nongreedily" do
      # we match the first 'hello'; but
      # then we need to be able to see the
      # second 'hello' as the start of a
      # new possible match
      hear "hello hello world"
      assert_matched
    end

    should "not match partial words" do
      hear "hello worlds"
      refute_matched
    end
  end

end
