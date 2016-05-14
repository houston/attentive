require "attentive/entity"
require "date"

month_names = Date::MONTHNAMES.compact.map(&:downcase)
Attentive::Entity.define "core.date.month", *month_names do |match|
  month_names.index(match.phrase) + 1
end
