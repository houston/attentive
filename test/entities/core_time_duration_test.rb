require "test_helper"

class CoreTimeDurationTest < Minitest::Test
  extend Attentive::Test::Entities


  entity("core.time.duration").should do
    match("1 second").as(Attentive::Duration.new(seconds: 1))
    match("30 seconds").as(Attentive::Duration.new(seconds: 30))
    match("1s").as(Attentive::Duration.new(seconds: 1))
    match("30s").as(Attentive::Duration.new(seconds: 30))

    match("1 minute").as(Attentive::Duration.new(minutes: 1))
    match("30 minutes").as(Attentive::Duration.new(minutes: 30))
    match("1min").as(Attentive::Duration.new(minutes: 1))
    match("30min").as(Attentive::Duration.new(minutes: 30))
    match("1m").as(Attentive::Duration.new(minutes: 1))
    match("30m").as(Attentive::Duration.new(minutes: 30))

    match("1 hour").as(Attentive::Duration.new(hours: 1))
    match("5 hours").as(Attentive::Duration.new(hours: 5))
    match("1hr").as(Attentive::Duration.new(hours: 1))
    match("5hrs").as(Attentive::Duration.new(hours: 5))
    match("1h").as(Attentive::Duration.new(hours: 1))
    match("5h").as(Attentive::Duration.new(hours: 5))

    match("1 hour, 3 minutes").as(Attentive::Duration.new(hours: 1, minutes: 3))
    match("5hrs 30min 12s").as(Attentive::Duration.new(hours: 5, minutes: 30, seconds: 12))
    match("5:30:12").as(Attentive::Duration.new(hours: 5, minutes: 30, seconds: 12))
    match("0:30:00").as(Attentive::Duration.new(minutes: 30))
    match("0:00:06").as(Attentive::Duration.new(seconds: 6))
  end


end
