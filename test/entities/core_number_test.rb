require "test_helper"

class CoreNumberTest < Minitest::Test
  extend Attentive::Test::Entities


  entity("core.number").should do
    match("0").as(0)
    match("4").as(4)
    match("-5").as(-5)
    match("6.75").as(BigDecimal.new("6.75"))
    match("451,972.00").as(BigDecimal.new("451972.00"))

    match("$6.45").as(BigDecimal.new("6.45"))
    match("12.3%").as(BigDecimal.new("12.3"))
    match("45mm").as(45)
    match("45'").as(45)
  end

  entity("core.number.positive").should do
    match("34,811").as(34811)
    match("1,348.66").as(BigDecimal.new("1348.66"))

    ignore("0")
    ignore("-100")
    ignore("-0.00125")
  end

  entity("core.number.negative").should do
    match("-100").as(-100)
    match("-0.00125").as(BigDecimal.new("-0.00125"))

    ignore("0")
    ignore("34,811")
    ignore("1,348.66")
  end


  entity("core.number.integer").should do
    match("0").as(0)
    match("4").as(4)
    match("-5").as(-5)

    ignore("0.5")
  end

  entity("core.number.integer.positive").should do
    match("4").as(4)

    ignore("0")
    ignore("-5")
  end

  entity("core.number.integer.negative").should do
    match("-5").as(-5)

    ignore("0")
    ignore("4")
  end


  entity("core.number.float").should do
    match("0.0").as(BigDecimal.new("0.0"))
    match("0.5").as(BigDecimal.new("0.5"))

    ignore("0")
    ignore("4")
    ignore("-5")
  end

  entity("core.number.float.positive").should do
    match("4.00").as(BigDecimal.new("4.00"))

    ignore("0.0")
    ignore("-5.99")
  end

  entity("core.number.float.negative").should do
    match("-5.99").as(BigDecimal.new("-5.99"))

    ignore("0.0")
    ignore("4.00")
  end


end
