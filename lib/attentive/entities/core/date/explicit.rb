require "attentive/entity"
require "date"

Attentive::Entity.define "core.date.explicit",
  "{{month:core.date.month}} {{day:core.number.integer.positive}} {{year:core.number.integer.positive}}",
  "{{day:core.number.integer.positive}} {{month:core.date.month}} {{year:core.number.integer.positive}}",
  %q{(?:(?<month>\d\d?)/(?<day>\d\d?)/(?<year>\d\d(?:\d\d)?))},
  %q{(?:(?<year>\d\d(?:\d\d)?)-(?<month>\d\d?)-(?<day>\d\d?))} do |match|

  month = match["month"].to_i
  day = match["day"].to_i
  year = match["year"].to_i

  nomatch! if day > 31 || month > 12

  begin
    Date.new(year, month, day)
  rescue ArgumentError
    nomatch!
  end
end
