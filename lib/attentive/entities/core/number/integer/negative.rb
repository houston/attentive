require "attentive/entity"

Attentive::Entity.define "core.number.integer.negative", "{{integer:core.number.integer}}" do |match|
  nomatch! if match["integer"] >= 0
  match["integer"]
end
