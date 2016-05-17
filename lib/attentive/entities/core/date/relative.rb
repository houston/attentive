require "attentive/entities/core/date/relative/past"
require "attentive/entities/core/date/relative/future"

Attentive::CompositeEntity.define "core.date.relative",
  "core.date.relative.future",
  "core.date.relative.past",
  published: false
