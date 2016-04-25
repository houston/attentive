require "test_helper"

class SplitterTest < Minitest::Test

  context "It" do
    should "split apart punctuation, words, and whitespace" do
      message = "Hello, friend\n"
      expected_strings = [
        "hello",
        ",",
        " ",
        "friend",
        "\n" ]
      assert_equal expected_strings, Attentive::Tokenizer.split(message)
    end

    should "treat @ as a word-character" do
      message = "Hello @slackbot"
      expected_strings = [
        "hello",
        " ",
        "@slackbot" ]
      assert_equal expected_strings, Attentive::Tokenizer.split(message)
    end

    should "treat ' as a word-character" do
      message = "it's me"
      expected_strings = [
        "it's",
        " ",
        "me" ]
      assert_equal expected_strings, Attentive::Tokenizer.split(message)
    end

    should "treat - as a word-character" do
      message = "mother-in-law"
      expected_strings = [
        "mother-in-law" ]
      assert_equal expected_strings, Attentive::Tokenizer.split(message)
    end

    should "treat ... as a single punctuation" do
      message = "Hello there..."
      expected_strings = [
        "hello",
        " ",
        "there",
        "..." ]
      assert_equal expected_strings, Attentive::Tokenizer.split(message)
    end
  end

end
