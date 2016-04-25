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



    DATA_PATH = File.expand_path(File.dirname(__FILE__) + "/../../data").freeze

    CONTRACTIONS = {}.tap do |contractions|
      File.open(DATA_PATH + "/contractions.tsv") do |file|
        file.each do |line|
          next if line.start_with?("#") # skip comments
          next if line == "\n" # skip blank lines

          # the file contains tab-separated values.
          # the first value is the contraction.
          # the remaining values are possible phrases that match it
          phrases = line.chomp.split("\t")
          raise "#{line.inspect} must have exactly two values" unless phrases.length >= 2

          contractions[phrases.shift] = phrases
        end
      end
    end.freeze

    SLANG = {}.tap do |slang|
      File.open(DATA_PATH + "/slang.tsv") do |file|
        file.each do |line|
          next if line.start_with?("#") # skip comments
          next if line == "\n" # skip blank lines

          # the file contains tab-separated values.
          # every line should have exactly two values:
          #  + the first is the slang word
          #  + the second is the normal word
          words = line.chomp.split("\t")
          raise "#{line.inspect} must have exactly two values" unless words.length == 2

          slang[words[0]] = words[1]
        end
      end
    end.freeze

  end
end
