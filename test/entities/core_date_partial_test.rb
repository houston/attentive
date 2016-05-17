require "test_helper"

class CoreDatePartialTest < Minitest::Test
  extend Attentive::Test::Entities

  def setup
    Timecop.freeze Date.new(2016, 4, 25)
  end

  def teardown
    Timecop.return
  end


  entity("core.date.partial.future").should do
    match("June 6").as(Date.new(2016, 6, 6)) # still in the future for this year
    match("Mar 1").as(Date.new(2017, 3, 1)) # has passed for this year
    ignore("February 29") # has passed for this year, does not occur next year

    # should not match impossible dates
    ignore("April -5")
    ignore("August 40")
    ignore("Unknown 7")
  end

  entity("core.date.partial.past").should do
    match("June 6").as(Date.new(2015, 6, 6)) # hasn't occured yet this year
    match("Mar 1").as(Date.new(2016, 3, 1)) # is in the past already this year
    match("February 29").as(Date.new(2016, 2, 29)) # does occur this year

    # should not match impossible dates
    ignore("April -5")
    ignore("August 40")
    ignore("Unknown 7")
  end


end
