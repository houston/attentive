require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

namespace :compile do

  desc "Compile contractions.rb and abbreviations.rb"
  task :data do

    data_path = File.expand_path(File.dirname(__FILE__) + "/data")
    output_path = File.expand_path(File.dirname(__FILE__) + "/lib/attentive")

    contractions = {}
    File.open(data_path + "/contractions.tsv") do |file|
      file.each do |line|
        next if line.start_with?("#") # skip comments
        next if line == "\n" # skip blank lines

        # the file contains tab-separated values.
        # the first value is the contraction.
        # the remaining values are possible phrases that match it
        phrases = line.downcase.chomp.split("\t")
        raise "#{line.inspect} must have exactly two values" unless phrases.length >= 2

        contractions[phrases.shift] = phrases
      end
    end
    File.open(output_path + "/contractions.rb", "w") do |file|
      file.write <<-RUBY
module Attentive
  CONTRACTIONS = #{contractions.inspect}.freeze
end
      RUBY
    end

    abbreviations = {}
    File.open(data_path + "/abbreviations.tsv") do |file|
      file.each do |line|
        next if line.start_with?("#") # skip comments
        next if line == "\n" # skip blank lines

        # the file contains tab-separated values.
        # every line should have exactly two values:
        #  + the first is the slang word
        #  + the second is the normal word
        words = line.downcase.chomp.split("\t")
        raise "#{line.inspect} must have exactly two values" unless words.length == 2

        abbreviations[words[0]] = words[1]
      end
    end
    File.open(output_path + "/abbreviations.rb", "w") do |file|
      file.write <<-RUBY
module Attentive
  ABBREVIATIONS = #{abbreviations.inspect}.freeze
end
      RUBY
    end

  end

end

task :default => :spec
