require "test_helper"

class EntityTest < Minitest::Test
  include Attentive::Tokens


  context "A new Entity " do
    setup do
      Attentive::Entity.define :"b-count", "(?<b-count>b+)" do |match|
        match["b-count"].length
      end
    end

    should "be in the a global library of entities" do
      assert Attentive::Entity[:"b-count"]
    end

    should "be tokenizable" do
      assert_kind_of Attentive::Token, entity("b-count")
    end

    should "be a subclass of Attentive::Entity" do
      assert_includes Attentive::Entity[:"b-count"].ancestors, Attentive::Entity
    end

    should "match any of the phrases it defines" do
      assert entity("b-count").matches?(Attentive::Cursor.new([word("bbb", pos: 0)]))
    end

    should "return a hash assigning a value to the variable defined by the listener" do
      token = entity("b-count", "n")
      match = token.matches?(Attentive::Cursor.new([word("bbbbb", pos: 0)]))
      assert_equal({n: 5}, match)
    end
  end


  context "A new CompositeEntity" do
    setup do
      Attentive::Entity.define :"a-count", "(?<a-count>a+)" do |match|
        match["a-count"].length
      end
      Attentive::Entity.define :"b-count", "(?<b-count>b+)" do |match|
        match["b-count"].length
      end
      Attentive::CompositeEntity.define :"runlength", :"a-count", :"b-count"
    end

    should "be in the a global library of entities" do
      assert Attentive::Entity[:"runlength"]
    end

    should "be tokenizable" do
      assert_kind_of Attentive::Token, entity("runlength")
    end

    should "be a subclass of Attentive::Entity" do
      assert_includes Attentive::Entity[:"runlength"].ancestors, Attentive::Entity
    end

    should "match any of the phrases it defines" do
      assert entity("runlength").matches?(Attentive::Cursor.new([word("bbb", pos: 0)]))
      assert entity("runlength").matches?(Attentive::Cursor.new([word("aaaa", pos: 0)]))
    end

    should "return a hash assigning a value to the variable defined by the listener" do
      token = entity("runlength", "n")
      match = token.matches?(Attentive::Cursor.new([word("aaa", pos: 0)]))
      assert_equal({n: 3}, match)
    end
  end


end
