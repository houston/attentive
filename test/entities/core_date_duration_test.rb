require "test_helper"

class CoreDateDurationTest < Minitest::Test
  extend Attentive::Test::Entities


  entity("core.date.duration").should do
    match("1 day").as(Attentive::Duration.new(days: 1))
    match("3 days").as(Attentive::Duration.new(days: 3))

    match("1 week").as(Attentive::Duration.new(days: 7))
    match("1wk").as(Attentive::Duration.new(days: 7))
    match("3 weeks").as(Attentive::Duration.new(days: 21))
    match("3wks").as(Attentive::Duration.new(days: 21))

    match("1 month").as(Attentive::Duration.new(months: 1))
    match("1mo").as(Attentive::Duration.new(months: 1))
    match("3 month").as(Attentive::Duration.new(months: 3))
    match("3mos").as(Attentive::Duration.new(months: 3))

    match("1 year").as(Attentive::Duration.new(years: 1))
    match("1yr").as(Attentive::Duration.new(years: 1))
    match("3 years").as(Attentive::Duration.new(years: 3))
    match("3yrs").as(Attentive::Duration.new(years: 3))

    match("1 year, 7 months").as(Attentive::Duration.new(years: 1, months: 7))
    match("1 year, 7 months, and 11 days").as(Attentive::Duration.new(years: 1, months: 7, days: 11))
    match("3 weeks and 4 days").as(Attentive::Duration.new(days: 25))
    match("1 year and 3 years").as(Attentive::Duration.new(years: 4))
  end


end
