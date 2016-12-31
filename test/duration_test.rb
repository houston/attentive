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


  context "#to_s" do
    should "work" do
      assert_equal "1 year", duration(years: 1).to_s
      assert_equal "1 month", duration(months: 1).to_s
      assert_equal "1 day", duration(days: 1).to_s

      assert_equal "2 years", duration(years: 2).to_s
      assert_equal "2 months", duration(months: 2).to_s
      assert_equal "2 days", duration(days: 2).to_s

      assert_equal "1 year and 1 month", duration(years: 1, months: 1).to_s
      assert_equal "1 year, 1 month, and 2 days", duration(years: 1, months: 1, days: 2).to_s
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
