require "test_helper"

class CoreDateExplicitTest < Minitest::Test
  extend Attentive::Test::Entities


  entity("core.date.explicit").should do
    match("2016-04-20").as(Date.new(2016, 4, 20))
    match("2016-4-20").as(Date.new(2016, 4, 20))
    match("2016-4-1").as(Date.new(2016, 4, 1))
    match("2016-04-20 trailing text is ignored").as(Date.new(2016, 4, 20))

    match("4/20/2016").as(Date.new(2016, 4, 20))
    match("4/20/16").as(Date.new(2016, 4, 20))

    match("April 20, 2016").as(Date.new(2016, 4, 20))
    match("Apr 20, 2016").as(Date.new(2016, 4, 20))
    match("Jul 20 2016").as(Date.new(2016, 7, 20))
    match("Aug 20 ,2016").as(Date.new(2016, 8, 20))
    match("Sept 01, 2016").as(Date.new(2016, 9, 1))
    match("January 1, 2016").as(Date.new(2016, 1, 1))

    match("20 April 2016").as(Date.new(2016, 4, 20))
    match("01 April 2016").as(Date.new(2016, 4, 1))
  end


end
