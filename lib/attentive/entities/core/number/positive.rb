require "attentive/entity"

Attentive::Entity.define "core.number.positive", "{{number:core.number}}" do |match|
  nomatch! if match["number"] < 0
  match["number"]
end
