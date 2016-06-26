require "attentive/entities/core/date/month"
require "attentive/entities/core/date/wday"
require "attentive/entities/core/date/duration"
require "attentive/entities/core/date/relative"
require "attentive/entities/core/date/partial"
require "attentive/entities/core/date/explicit"

require "attentive/entities/core/date/future"
require "attentive/entities/core/date/past"

Attentive::CompositeEntity.define "core.date",
  "core.date.explicit",
  "core.date.relative",
  "core.date.partial"
