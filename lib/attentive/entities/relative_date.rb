require "attentive/entity"
require "date"

weekday_regexp = "(?<weekday>sunday|monday|tuesday|wednesday|thursday|friday|saturday)"
Attentive::Entity.define :"relative-date",
    "today",
    "tomorrow",
    "yesterday",
    weekday_regexp,
    "next #{weekday_regexp}",
    "last #{weekday_regexp}" do |match|

  today = Date.today

  next_wday = lambda do |wday|
    days_until_wday = wday - today.wday
    days_until_wday += 7 if days_until_wday < 0
    today + days_until_wday
  end

  if match.matched?("weekday")
    date = case weekday = match["weekday"]
    when /^sun/ then next_wday[0]
    when /^mon/ then next_wday[1]
    when /^tue/ then next_wday[2]
    when /^wed/ then next_wday[3]
    when /^thu/ then next_wday[4]
    when /^fri/ then next_wday[5]
    when /^sat/ then next_wday[6]
    else raise NotImplementedError, "Unrecognized weekday: #{weekday.inspect}"
    end

    date += 7 if match.to_s.start_with?("next")
    date -= 7 if match.to_s.start_with?("last")
    date
  else
    case match.to_s
    when "today" then today
    when "tomorrow" then today + 1
    when "yesterday" then today - 1
    else raise NotImplementedError, "Unrecognized match: #{match.to_s}"
    end
  end
end
