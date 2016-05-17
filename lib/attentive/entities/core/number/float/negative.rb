require "attentive/entity"

Attentive::Entity.define "core.number.float.negative", "{{float:core.number.float}}", published: false do |match|
  nomatch! if match["float"] >= 0
  match["float"]
end
