require "attentive/entities/core/number/integer"
require "attentive/entities/core/number/float"
require "attentive/entities/core/number/positive"
require "attentive/entities/core/number/negative"

Attentive::CompositeEntity.define "core.number",
  "core.number.float",
  "core.number.integer"
