require "attentive/entity"
require "bigdecimal"

Attentive::Entity.define "core.number.float", %q{(?<float>\-?[\d,]+\.\d+)} do |match|
  BigDecimal.new(match["float"].gsub(",", ""))
end

require "attentive/entities/core/number/float/positive"
require "attentive/entities/core/number/float/negative"
