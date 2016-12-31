module Attentive
  class Duration < Struct.new(:years, :months, :days, :hours, :minutes, :seconds)

    def initialize(attributes)
      super(
        attributes.fetch(:years, 0),
        attributes.fetch(:months, 0),
        attributes.fetch(:days, 0),
        attributes.fetch(:hours, 0),
        attributes.fetch(:minutes, 0),
        attributes.fetch(:seconds, 0))
    end

    def +(other)
      self.class.new(
        years: years + other.years,
        months: months + other.months,
        days: days + other.days,
        hours: hours + other.hours,
        minutes: minutes + other.minutes,
        seconds: seconds + other.seconds)
    end

    def inspect
      "<#{to_s}>"
    end

    def to_s
      phrases = []
      phrases.push "#{years} #{years > 1 ? "years" : "year"}" if years > 0
      phrases.push "#{months} #{months > 1 ? "months" : "month"}" if months > 0
      phrases.push "#{days} #{days > 1 ? "days" : "day"}" if days > 0
      phrases.push "#{hours} #{hours > 1 ? "hours" : "hour"}" if hours > 0
      phrases.push "#{minutes} #{minutes > 1 ? "minutes" : "minute"}" if minutes > 0
      phrases.push "#{seconds} #{seconds > 1 ? "seconds" : "second"}" if seconds > 0

      case phrases.length
      when 0 then ""
      when 1 then phrases[0]
      when 2 then phrases.join(" and ")
      else "#{phrases[0...-1].join(", ")}, and #{phrases[-1]}"
      end
    end

    def after(date)
      (date >> (years * 12 + months)) + days
    end

    def before(date)
      (date >> -(years * 12 + months)) - days
    end

  end
end
