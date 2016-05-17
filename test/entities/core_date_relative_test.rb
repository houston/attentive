require "test_helper"

class CoreDateRelativeTest < Minitest::Test
  extend Attentive::Test::Entities

  def setup
    Timecop.freeze Date.new(2016, 4, 25)
  end

  def teardown
    Timecop.return
  end


  entity("core.date.relative").should do
    match("tuesday").as(Date.new(2016, 4, 26))
    match("today").as(Date.new(2016, 4, 25))
    match("yesterday").as(Date.new(2016, 4, 24))
    match("tomorrow").as(Date.new(2016, 4, 26))
    match("last friday").as(Date.new(2016, 4, 22))
    match("next friday").as(Date.new(2016, 5, 6))
  end

  entity("core.date.relative.past").should do
    match("tuesday").as(Date.new(2016, 4, 19))
    match("friday").as(Date.new(2016, 4, 22))
    match("last tuesday").as(Date.new(2016, 4, 19))
    match("today").as(Date.new(2016, 4, 25))
    match("yesterday").as(Date.new(2016, 4, 24))

    ignore("tomorrow")
  end

  entity("core.date.relative.future").should do
    match("sunday").as(Date.new(2016, 5, 1))
    match("today").as(Date.new(2016, 4, 25))
    match("tomorrow").as(Date.new(2016, 4, 26))
    match("next friday").as(Date.new(2016, 5, 6))

    ignore("yesterday")
  end


end
