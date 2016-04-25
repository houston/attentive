require "test_helper"

class RegexpTest < Minitest::Test
  include Attentive::Test::Matching

  self.default_context = %i{conversation}

  context "It" do
    should "match a simple regular expression in the middle of a message" do
      listen_for %q{assign #(?<number>\d+) to me}
      hear "assign #173 to me"
      assert_matched
    end

    should "match a regular expression that spans more than one token in the middle of a message" do
      listen_for %q{email (?<email>[\w\.]+\@[\w\.]+\.[\w\.]+) those results}
      hear "email bob.lailfamily@gmail.com those results"
      assert_matched
    end
  end

end
