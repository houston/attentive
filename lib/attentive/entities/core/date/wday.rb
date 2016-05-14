require "attentive/entity"
require "date"

day_names = Date::DAYNAMES.map(&:downcase)
Attentive::Entity.define "core.date.wday", *day_names do |match|
  day_names.index(match.phrase)
end
