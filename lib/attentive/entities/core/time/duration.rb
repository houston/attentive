require "attentive/entity"
require "attentive/duration"
require "attentive/entities/core/time/duration/units"

Attentive::Entity.define "core.time.duration.single",
    "{{n:core.number.integer.positive}} {{unit:core.time.duration.units}}",
    published: false do |match|

  unit = match["unit"]
  n = match["n"]
  Attentive::Duration.new(unit => n)

end

Attentive::Entity.define "core.time.duration",
    %q{(?:(?<hours>\d\d?):(?<minutes>\d\d):(?<seconds>\d\d))},
    "{{a:core.time.duration.single}} {{b:core.time.duration}}",
    "{{a:core.time.duration.single}} and {{b:core.time.duration}}",
    "{{a:core.time.duration.single}}" do |match|

  if match.matched?("hours")
    return Attentive::Duration.new(
      hours: match["hours"],
      minutes: match["minutes"],
      seconds: match["seconds"])
  else
    a = match["a"]
    a += match["b"] if match.matched?("b")
    a
  end

end
