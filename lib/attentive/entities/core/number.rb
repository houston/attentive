require "attentive/entity"
require "bigdecimal"

Attentive::Entity.define "core.number", %q{(?<number>(?<integer-part>\-?[\d,]+)(?:\.(?<decimal-part>\d+))?)} do |match|
  integer = match["integer-part"].gsub(",", "")
  decimal = match["decimal-part"]
  decimal ? BigDecimal.new("#{integer}.#{decimal}") : integer.to_i
end
