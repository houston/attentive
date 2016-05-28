require "attentive/entities/core/date/month"
require "attentive/entities/core/date/wday"
require "attentive/entities/core/date/relative"
require "attentive/entities/core/date/partial"
require "attentive/entities/core/date/explicit"

Attentive::CompositeEntity.define "core.date.future",
  "core.date.explicit",
  "core.date.relative.future",
  "core.date.partial.future",
  published: false
