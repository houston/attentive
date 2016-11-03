require "test_helper"

class CoreTimeTest < Minitest::Test
  extend Attentive::Test::Entities

  def self.time(hours, minutes)
    today = Date.today; Time.new(today.year, today.month, today.day, hours, minutes)
  end


  entity("core.time").should do
    match("noon").as(time(12, 00))
    match("midnight").as(time(00, 00))

    match("10am").as(time(10, 00))
    match("10 PM").as(time(22, 00))

    match("11:08a").as(time(11, 8))
    match("11:08p").as(time(23, 8))

    match("07:45").as(time(7, 45))
    match("7:45").as(time(7, 45))

    ignore("38am")
    ignore("6:67p")
  end

end
