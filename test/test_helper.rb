$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "attentive"

require "minitest/reporters/turn_reporter"
MiniTest::Reporters.use! Minitest::Reporters::TurnReporter.new

require "shoulda/context"
require "timecop"
require "rr"
require "support/matching_helpers"
require "support/entities_helpers"
require "minitest/autorun"
