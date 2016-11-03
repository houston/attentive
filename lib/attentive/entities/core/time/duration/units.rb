require "attentive/entity"

Attentive::Entity.define "core.time.duration.units",
    "second",
    "seconds",
    "s",
    "minute",
    "minutes",
    "min",
    "m",
    "hour",
    "hours",
    "hr",
    "hrs",
    "h",
    published: false do |match|

  case match.phrase
  when "second", "seconds", "s" then :seconds
  when "minute", "minutes", "min", "m" then :minutes
  when "hour", "hours", "hr", "hrs", "h" then :hours
  else
    nomatch!
  end
end
