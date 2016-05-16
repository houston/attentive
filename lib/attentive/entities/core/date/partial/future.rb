require "attentive/entity"
require "date"

Attentive::Entity.define "core.date.partial.future",
    "{{month:core.date.month}} {{day:core.number.integer.positive}}" do |match|

  month = match["month"]
  day = match["day"]
  nomatch! if day > 31

  today = Date.today
  year = today.year
  year += 1 if month < today.month || (month == today.month && day < today.day)

  begin
    Date.new(year, month, day)
  rescue ArgumentError
    nomatch!
  end
end
