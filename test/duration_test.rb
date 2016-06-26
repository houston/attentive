require "test_helper"

class DurationTest < Minitest::Test


  context "#after" do
    should "work" do
      assert_equal date(2017, 3, 15), duration(years: 1).after(date(2016, 3, 15))
      assert_equal date(2016, 4, 15), duration(months: 1).after(date(2016, 3, 15))
      assert_equal date(2016, 3, 16), duration(days: 1).after(date(2016, 3, 15))

      assert_equal date(2016, 2, 29), duration(months: 1).after(date(2016, 1, 31))
      assert_equal date(2016, 3, 31), duration(months: 2).after(date(2016, 1, 31))
    end
  end


  context "#before" do
    should "work" do
      assert_equal date(2015, 3, 15), duration(years: 1).before(date(2016, 3, 15))
      assert_equal date(2016, 2, 15), duration(months: 1).before(date(2016, 3, 15))
      assert_equal date(2016, 3, 14), duration(days: 1).before(date(2016, 3, 15))

      assert_equal date(2016, 2, 29), duration(months: 1).before(date(2016, 3, 31))
      assert_equal date(2016, 1, 31), duration(months: 2).before(date(2016, 3, 31))
    end
  end


private

  def date(*args)
    Date.new(*args)
  end

  def duration(attributes={})
    Attentive::Duration.new(attributes)
  end

end
