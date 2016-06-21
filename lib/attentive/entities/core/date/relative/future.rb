require "attentive/entity"
require "date"

Attentive::Entity.define "core.date.relative.future",
    "today",
    "tomorrow",
    "{{core.date.wday}}",
    "next {{core.date.wday}}",
    published: false do |match|

  today = Date.today

  if match.matched?("core.date.wday")
    wday = match["core.date.wday"]
    days_until_wday = wday - today.wday
    days_until_wday += 7 if days_until_wday < 0
    date = today + days_until_wday

    date += 7 if match.to_s.start_with?("next")
    date
  else
    case match.to_s
    when "today" then today
    when "tomorrow" then today + 1
    else nomatch!
    end
  end
end
