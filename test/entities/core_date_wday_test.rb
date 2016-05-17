require "test_helper"

class CoreDateWdayTest < Minitest::Test
  extend Attentive::Test::Entities


  entity("core.date.wday").should do
    match("Sunday").as(0)
    match("Monday").as(1)
    match("Tuesday").as(2)
    match("Wednesday").as(3)
    match("Thursday").as(4)
    match("Friday").as(5)
    match("Saturday").as(6)

    match("sun").as(0)
    match("mon").as(1)
    match("tue").as(2)
    match("tues").as(2)
    match("wed").as(3)
    match("thu").as(4)
    match("thur").as(4)
    match("thurs").as(4)
    match("fri").as(5)
    match("sat").as(6)

    match("saturday night").as(6)
    match("mon night").as(1)

    ignore("tomorrow")
  end


end
