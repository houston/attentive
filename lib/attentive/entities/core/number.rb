require "attentive/entities/core/number/integer"
require "attentive/entities/core/number/float"

Attentive::CompositeEntity.define "core.number",
  "core.number.float",
  "core.number.integer"

require "attentive/entities/core/number/positive"
require "attentive/entities/core/number/negative"
