require "attentive/entities/core/time/duration"
require "date"
require "time"

Attentive::Entity.define "core.time",
    "noon",
    "midnight",
    %q{(?:(?<hours>\d\d?):(?<minutes>\d\d)\s*(?<pm>pm?))},
    %q{(?:(?<hours>\d\d?)\s*(?:am?|(?<pm>pm?)))},
    %q{(?:(?<hours>\d\d?):(?<minutes>\d\d))} do |match|

  minutes = 0

  if match.matched?("hours")
    hours = match["hours"].to_i
    hours += 12 if hours < 12 && match.matched?("pm")
    hours = 0 if hours == 12 && !match.matched?("pm")
    minutes = match["minutes"].to_i if match.matched?("minutes")
  else
    case match.to_s
    when "noon" then hours = 12
    when "midnight" then hours = 0
    else nomatch!
    end
  end

  nomatch! if hours < 0 || hours > 23
  nomatch! if minutes < 0 || minutes > 60

  today = Date.today; Time.new(today.year, today.month, today.day, hours, minutes)
end
