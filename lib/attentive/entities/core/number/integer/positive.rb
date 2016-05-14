require "attentive/entity"

Attentive::Entity.define "core.number.integer.positive", %q{(?<integer>[\d,]+)} do |match|
  match["integer"].gsub(",", "").to_i
end
