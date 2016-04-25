require "attentive/entity"

Attentive::Entity.define :integer, %q{(?<integer>\d+)} do |match|
  match["integer"].to_i
end
