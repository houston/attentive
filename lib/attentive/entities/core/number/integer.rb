Attentive::Entity.define "core.number.integer", %q{(?<integer>\-?[\d,]+)}, published: false do |match|
  match["integer"].gsub(",", "").to_i
end

require "attentive/entities/core/number/integer/positive"
require "attentive/entities/core/number/integer/negative"
