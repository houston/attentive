require "attentive/entity"
require "bigdecimal"

Attentive::Entity.define "core.number.float", %q{(?<float>\-?[\d,]+\.\d+)}, published: false do |match|
  BigDecimal.new(match["float"].gsub(",", ""))
end

require "attentive/entities/core/number/float/positive"
require "attentive/entities/core/number/float/negative"
