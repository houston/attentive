require "test_helper"

class CoreDateMonthTest < Minitest::Test
  extend Attentive::Test::Entities


  entity("core.date.month").should do
    match("January").as(1)
    match("February").as(2)
    match("March").as(3)
    match("April").as(4)
    match("May").as(5)
    match("June").as(6)
    match("July").as(7)
    match("August").as(8)
    match("September").as(9)
    match("October").as(10)
    match("November").as(11)
    match("December").as(12)

    match("jan").as(1)
    match("feb").as(2)
    match("mar").as(3)
    match("apr").as(4)
    match("jun").as(6)
    match("jul").as(7)
    match("aug").as(8)
    match("sep").as(9)
    match("sept").as(9)
    match("oct").as(10)
    match("nov").as(11)
    match("dec").as(12)

    ignore("spring")
    ignore("4")
  end


end
