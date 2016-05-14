require "test_helper"

class TokenizerTest < Minitest::Test
  include Attentive::Tokens

  context "It" do
    should "identify words as words" do
      assert_tokens "hello world", [
        word("hello"),
        whitespace(" "),
        word("world")
      ]
    end

    should "identify apostrophes, dashes, and underscores as word characters" do
      assert_tokens "jim's bot_user is a bot-user", [
        word("jim's"),
        whitespace(" "),
        word("bot_user"),
        whitespace(" "),
        word("is"),
        whitespace(" "),
        word("a"),
        whitespace(" "),
        word("bot-user")
      ]
    end

    should "identify other puncutation marks" do
      assert_tokens "hello, world: i'm here...", [
        word("hello"),
        punctuation(","),
        whitespace(" "),
        word("world"),
        punctuation(":"),
        whitespace(" "),
        word("i"),
        whitespace(" "),
        word("am"),
        whitespace(" "),
        word("here"),
        punctuation("...")
      ]
    end

    should "identify emoji" do
      assert_tokens "hello world :rocket:", [
        word("hello"),
        whitespace(" "),
        word("world"),
        whitespace(" "),
        emoji("rocket")
      ]
    end

    context "when matching entities" do
      should "identify entities" do
        assert_tokens "what is for lunch on {{core.date}}?", [
          word("what"),
          whitespace(" "),
          word("is"),
          whitespace(" "),
          word("for"),
          whitespace(" "),
          word("lunch"),
          whitespace(" "),
          word("on"),
          whitespace(" "),
          entity("core.date"),
          punctuation("?")
        ], entities: true
      end

      should "identify entities and their aliases" do
        assert_tokens "remind me in {{hours:core.number}} hours", [
          word("remind"),
          whitespace(" "),
          word("me"),
          whitespace(" "),
          word("in"),
          whitespace(" "),
          entity("core.number", "hours"),
          whitespace(" "),
          word("hours")
        ], entities: true
      end
    end

    context "when not matching entities" do
      should "not identify entities" do
        assert_tokens "what is for lunch on {{core.date}}?", [
          word("what"),
          whitespace(" "),
          word("is"),
          whitespace(" "),
          word("for"),
          whitespace(" "),
          word("lunch"),
          whitespace(" "),
          word("on"),
          whitespace(" "),
          punctuation("{{"),
          word("core"),
          punctuation("."),
          word("date"),
          punctuation("}}"),
          punctuation("?")
        ]
      end
    end

    should "treat a : that's not part of an entity or emoji as puncutation" do
      assert_tokens "avengers: assemble", [
        word("avengers"),
        punctuation(":"),
        whitespace(" "),
        word("assemble")
      ], entities: true
    end

    should "expand slang" do
      assert_tokens "'sup", [
        word("what"),
        whitespace(" "),
        word("is"),
        whitespace(" "),
        word("up")
      ]
    end

    should "expand contractions" do
      assert_tokens "i ain't afraid", [
        word("i"),
        whitespace(" "),
        word("am"),
        whitespace(" "),
        word("not"),
        whitespace(" "),
        word("afraid")
      ]
    end

    should "identity ambigous contractions as possibilities" do
      assert_tokens "what's that?", [
        any_of([
          [ word("what"),
            whitespace(" "),
            word("is") ],
          [ word("what"),
            whitespace(" "),
            word("does") ],
          [ word("what"),
            whitespace(" "),
            word("has") ]
        ]),
        whitespace(" "),
        word("that"),
        punctuation("?")
      ]
    end

    should "identity the special @me mention" do
      assert_tokens "hello, @me", [
        word("hello"),
        punctuation(","),
        whitespace(" "),
        invocation("@me")
      ]
    end

    context "whatever Attentive.me may be defined as, it" do
      setup { Attentive.invocations = ["@example", "@me"] }
      teardown { Attentive.invocations = ["@me"] }

      should "identify the special @me mention" do
        assert_tokens "hello, @example", [
          word("hello"),
          punctuation(","),
          whitespace(" "),
          invocation("@example")
        ]
      end
    end

    should "identify regular expressions" do
      assert_tokens "(?<answer>yes|no)", [
        regexp(%q{(?<answer>yes|no)})
      ], regexps: true
    end

    should "identify regular expressions that contain an escaped parethesis" do
      assert_tokens %q{(?<phonenumber>\(\d{3}\) \d{3}-\d{4})}, [
        regexp(%q{(?<phonenumber>\(\d{3}\) \d{3}-\d{4})})
      ], regexps: true
    end

    should "identify regular expressions that contain nested parentheses" do
      assert_tokens "I (?:(?<yes>accept)|(?<no>regretfully decline)) your invitation", [
        word("i"),
        whitespace(" "),
        regexp("(?:(?<yes>accept)|(?<no>regretfully decline))"),
        whitespace(" "),
        word("your"),
        whitespace(" "),
        word("invitation")
      ], regexps: true
    end

    should "identify regular expressions that contain parentheses inside square brackets" do
      assert_tokens %q{(?<aside>\([^)]+\))}, [
        regexp(%q{(?<aside>\([^)]+\))})
      ], regexps: true
    end

    should "not identify invalid regular expressions" do
      assert_tokens "(?<answer>yes|no", [
        punctuation("("),
        punctuation("?"),
        punctuation("<"),
        word("answer"),
        punctuation(">"),
        word("yes"),
        punctuation("|"),
        word("no")
      ], regexps: true
    end



    # Normalization


    should "straighten curly apostrophes" do
      assert_tokens "o’reilly", [
        word("o'reilly")
      ]
    end

    should "downcase everything" do
      assert_tokens "O'Reilly", [
        word("o'reilly")
      ]
    end
  end

private

  def assert_tokens(message, expected_tokens, options={})
    tokens = Attentive::Tokenizer.tokenize(message, options)
    assert_equal expected_tokens, tokens
  end

end
