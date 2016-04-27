module Attentive
  module Text
    extend self

    def normalize(text)
      straighten_quotes downcase text
    end

    def downcase(text)
      text.downcase
    end

    def straighten_quotes(text)
      text.gsub(/[“”]/, "\"").gsub(/[‘’]/, "'")
    end

  end
end
