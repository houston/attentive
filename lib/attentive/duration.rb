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
      phrases = []
      phrases.push "#{years} years" if years > 0
      phrases.push "#{months} months" if months > 0
      phrases.push "#{days} days" if days > 0
      phrases.push "#{hours} hours" if hours > 0
      phrases.push "#{minutes} minutes" if minutes > 0
      phrases.push "#{seconds} seconds" if seconds > 0
      "<#{phrases.join(" ")}>"
    end

    def after(date)
      (date >> (years * 12 + months)) + days
    end

    def before(date)
      (date >> -(years * 12 + months)) - days
    end

  end
end
