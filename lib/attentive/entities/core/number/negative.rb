require "attentive/entity"

Attentive::Entity.define "core.number.negative", "{{number:core.number}}", published: false do |match|
  nomatch! if match["number"] >= 0
  match["number"]
end
