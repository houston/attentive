require "test_helper"

class CoreDateTest < Minitest::Test
  extend Attentive::Test::Entities

  def setup
    Timecop.freeze Date.new(2016, 4, 25)
  end

  def teardown
    Timecop.return
  end


  entity("core.date").should do
    match("2016-04-20").as(Date.new(2016, 4, 20))
    match("4/20/2016").as(Date.new(2016, 4, 20))
    match("4/20/16").as(Date.new(2016, 4, 20))
    match("april 20, 2016").as(Date.new(2016, 4, 20))
    match("20 april 2016").as(Date.new(2016, 4, 20))

    match("sep 16").as(Date.new(2016, 9, 16))

    match("yesterday").as(Date.new(2016, 4, 24))
    match("today").as(Date.new(2016, 4, 25))
    match("tomorrow").as(Date.new(2016, 4, 26))
    match("saturday").as(Date.new(2016, 4, 30))

    match("next tuesday").as(Date.new(2016, 5, 3))
    match("last friday").as(Date.new(2016, 4, 22))
  end


end
