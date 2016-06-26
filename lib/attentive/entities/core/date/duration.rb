require "attentive/entity"
require "attentive/duration"
require "attentive/entities/core/date/duration/units"

Attentive::Entity.define "core.date.duration.single",
    "{{n:core.number.integer.positive}} {{unit:core.date.duration.units}}",
    published: false do |match|

  unit = match["unit"]
  n = match["n"]
  unit, n = [:days, n * 7] if unit == :weeks
  Attentive::Duration.new(unit => n)

end

Attentive::Entity.define "core.date.duration",
    "{{a:core.date.duration.single}} {{b:core.date.duration}}",
    "{{a:core.date.duration.single}} and {{b:core.date.duration}}",
    "{{a:core.date.duration.single}}" do |match|

  a = match["a"]
  a += match["b"] if match.matched?("b")
  a

end
