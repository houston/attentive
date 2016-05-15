require "attentive/entity"

Attentive::Entity.define "core.number.negative", "{{number:core.number}}" do |match|
  nomatch! if match["number"] >= 0
  match["number"]
end
