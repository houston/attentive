require "test_helper"

class EntityTest < Minitest::Test
  include Attentive::Tokens


  context "A new Entity " do
    setup do
      Attentive::Entity.define "runlength.b", "(?<b>b+)" do |match|
        match["b"].length
      end
    end

    teardown do
      Attentive::Entity.undefine "runlength.b"
    end

    should "be in the a global library of entities" do
      assert Attentive::Entity["runlength.b"]
    end

    should "be tokenizable" do
      assert_kind_of Attentive::Token, entity("runlength.b")
    end

    should "be a subclass of Attentive::Entity" do
      assert_includes Attentive::Entity["runlength.b"].ancestors, Attentive::Entity
    end

    should "match any of the phrases it defines" do
      assert entity("runlength.b").matches?(Attentive::Cursor.new([word("bbb", pos: 0)]))
    end

    should "return a hash assigning a value to the variable defined by the listener" do
      token = entity("runlength.b", "n")
      match = token.matches?(Attentive::Cursor.new([word("bbbbb", pos: 0)]))
      assert_equal({"n" => 5}, match)
    end
  end


  context "A new CompositeEntity" do
    setup do
      Attentive::Entity.define "runlength.a", "(?<a>a+)" do |match|
        match["a"].length
      end
      Attentive::Entity.define "runlength.b", "(?<b>b+)" do |match|
        match["b"].length
      end
      Attentive::CompositeEntity.define "runlength", "runlength.a", "runlength.b"
    end

    teardown do
      Attentive::Entity.undefine "runlength"
      Attentive::Entity.undefine "runlength.a"
      Attentive::Entity.undefine "runlength.b"
    end

    should "be in the a global library of entities" do
      assert Attentive::Entity["runlength"]
    end

    should "be tokenizable" do
      assert_kind_of Attentive::Token, entity("runlength")
    end

    should "be a subclass of Attentive::Entity" do
      assert_includes Attentive::Entity["runlength"].ancestors, Attentive::Entity
    end

    should "match any of the phrases it defines" do
      assert entity("runlength").matches?(Attentive::Cursor.new([word("bbb", pos: 0)]))
      assert entity("runlength").matches?(Attentive::Cursor.new([word("aaaa", pos: 0)]))
    end

    should "return a hash assigning a value to the variable defined by the listener" do
      token = entity("runlength", "n")
      match = token.matches?(Attentive::Cursor.new([word("aaa", pos: 0)]))
      assert_equal({"n" => 3}, match)
    end
  end


end
