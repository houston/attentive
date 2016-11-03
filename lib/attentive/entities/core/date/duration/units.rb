require "attentive/entity"

Attentive::Entity.define "core.date.duration.units",
    "day",
    "days",
    "week",
    "wk",
    "weeks",
    "wks",
    "month",
    "mo",
    "months",
    "mos",
    "year",
    "yr",
    "years",
    "yrs",
    published: false do |match|

  case match.phrase
  when "day", "days" then :days
  when "week", "wk", "weeks", "wks" then :weeks
  when "month", "mo", "months", "mos" then :months
  when "year", "yr", "years", "yrs" then :years
  else
    nomatch!
  end
end
