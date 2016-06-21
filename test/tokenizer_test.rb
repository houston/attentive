require "test_helper"

class TokenizerTest < Minitest::Test
  include Attentive::Tokens

  context "It" do
    should "separate words from whitespace" do
      assert_tokens "hello world", [
        word("hello"),
        whitespace(" "),
        word("world")
      ]
    end

    should "identify underscores as word characters" do
      assert_tokens "bot_user", [
        word("bot_user")
      ]
    end

    should "identify other punctuation marks" do
      assert_tokens "hello, world: Attentive's here!", [
        word("hello"),
        punctuation(","),
        whitespace(" "),
        word("world"),
        punctuation(":"),
        whitespace(" "),
        word("attentive"),
        punctuation("'"),
        word("s"),
        whitespace(" "),
        word("here"),
        punctuation("!")
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

    should "treat a dash in front of a number as part of the number" do
      assert_tokens "-20", [
        word("-20")
      ]
    end

    should "treat a dash in the middle of a number as breaking that number" do
      assert_tokens "04-20", [
        word("04"),
        word("-20")
      ]
    end

    should "identify . and , as number characters when they are adjacent to numbers" do
      assert_tokens "4.55 6,450,798 .2", [
        word("4.55"),
        whitespace(" "),
        word("6,450,798"),
        whitespace(" "),
        word(".2")
      ]
    end

    should "identify . and , as punctuation when they are not adjacent to numbers" do
      assert_tokens "4. 6, 450 .b", [
        word("4"),
        punctuation("."),
        whitespace(" "),
        word("6"),
        punctuation(","),
        whitespace(" "),
        word("450"),
        whitespace(" "),
        punctuation("."),
        word("b")
      ]
    end



    context "with {entities: true}" do
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
          entity("hours:core.number"),
          whitespace(" "),
          word("hours")
        ], entities: true
      end

      should "treat a : that's not part of an entity or emoji as punctuation" do
        assert_tokens "avengers: assemble", [
          word("avengers"),
          punctuation(":"),
          whitespace(" "),
          word("assemble")
        ], entities: true
      end
    end

    context "with {entities: false}" do
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
          punctuation("{"),
          punctuation("{"),
          word("core"),
          punctuation("."),
          word("date"),
          punctuation("}"),
          punctuation("}"),
          punctuation("?")
        ]
      end
    end



    context "with {substitutions: true}" do
      should "expand slang" do
        assert_tokens "'sup", [
          word("what"),
          whitespace(" "),
          word("is"),
          whitespace(" "),
          word("up")
        ]
      end

      should "expand abbreviations" do
        assert_tokens "mon", [
          word("monday")
        ]
      end

      should "expand shorthand" do
        assert_tokens "w/o", [
          word("without")
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

      should "correctly set the pos of replaced tokens" do
        expected = Attentive::Tokenizer.tokenize("i am not afraid").map(&:begin)
        actual = Attentive::Tokenizer.tokenize("i ain't afraid").map(&:begin)
        assert_equal expected, actual
      end

      should "expand contractions recursively" do
        assert_tokens "couldn't've", [
          word("could"),
          whitespace(" "),
          word("not"),
          whitespace(" "),
          word("have")
        ]
      end

      should "identify ambigous contractions as possibilities" do
        assert_tokens "what's that?", [
          any_of("what's", [
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

      context "and Attentive.invocations defined" do
        setup { Attentive.invocations = ["@example", "@me"] }
        teardown { Attentive.invocations = ["@me"] }

        should "identify invocations" do
          assert_tokens "hello, @example", [
            word("hello"),
            punctuation(","),
            whitespace(" "),
            invocation("@example")
          ]
        end
      end
    end

    context "with {substitutions: false}" do
      should "not expand abbreviations, slang, shorthand, or contractions" do
        assert_tokens "it ain't aug yet", [
          word("it"),
          whitespace(" "),
          word("ain"),
          punctuation("'"),
          word("t"),
          whitespace(" "),
          word("aug"),
          whitespace(" "),
          word("yet")
        ], substitutions: false
      end

      context "although Attentive.invocations defined" do
        setup { Attentive.invocations = ["@example", "@me"] }
        teardown { Attentive.invocations = ["@me"] }

        should "not identify invocations" do
          assert_tokens "hello, @example", [
            word("hello"),
            punctuation(","),
            whitespace(" "),
            punctuation("@"),
            word("example")
          ], substitutions: false
        end
      end
    end



    context "with {regexps: true}" do
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
    end



    # Normalization


    should "straighten curly apostrophes" do
      assert_tokens "o’reilly", [
        word("o"),
        punctuation("'"),
        word("reilly")
      ]
    end

    should "downcase everything" do
      assert_tokens "O'Reilly", [
        word("o"),
        punctuation("'"),
        word("reilly")
      ]
    end
  end

private

  def assert_tokens(message, expected_tokens, options={})
    tokens = Attentive::Tokenizer.tokenize(message, options).to_a
    assert_equal expected_tokens, tokens
  end

end
