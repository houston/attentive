require "attentive/entity"
require "date"

Attentive::Entity.define "core.date.relative.past",
    "today",
    "yesterday",
    "{{core.date.wday}}",
    "last {{core.date.wday}}",
    published: false do |match|

  today = Date.today

  if match.matched?("core.date.wday")
    wday = match["core.date.wday"]
    days_since_wday = today.wday - wday
    days_since_wday += 7 if days_since_wday < 0
    today - days_since_wday
  else
    case match.to_s
    when "today" then today
    when "yesterday" then today - 1
    else raise NotImplementedError, "Unrecognized match: #{match.to_s}"
    end
  end
end
