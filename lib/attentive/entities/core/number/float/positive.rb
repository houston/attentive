require "attentive/entity"

Attentive::Entity.define "core.number.float.positive", "{{float:core.number.float}}" do |match|
  nomatch! if match["float"] < 0
  match["float"]
end
