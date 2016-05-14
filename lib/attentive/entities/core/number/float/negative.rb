require "attentive/entity"
require "bigdecimal"

Attentive::Entity.define "core.number.float.negative", %q{(?<float>\-[\d,]+\.\d+)} do |match|
  BigDecimal.new(match["float"].gsub(",", ""))
end
