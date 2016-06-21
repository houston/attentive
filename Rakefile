require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

namespace :compile do

  desc "Compile substitutions.rb"
  task :data do

    data_path = File.expand_path(File.dirname(__FILE__) + "/data")
    output_path = File.expand_path(File.dirname(__FILE__) + "/lib/attentive")

    substitutions = {}
    File.open(data_path + "/substitutions.tsv") do |file|
      file.each do |line|
        next if line.start_with?("#") # skip comments
        next if line == "\n" # skip blank lines

        # the file contains tab-separated values.
        # the first value is the contraction.
        # the remaining values are possible phrases that match it
        phrases = line.downcase.chomp.split("\t")
        raise "#{line.inspect} must have at least two values" unless phrases.length >= 2

        substitutions[phrases.shift] = phrases
      end
    end
    File.open(output_path + "/substitutions.rb", "w") do |file|
      file.write <<-RUBY
require "attentive/trie"

module Attentive
  SUBSTITUTIONS = #{substitutions.inspect}.each_with_object({}) do |(key, values), new_hash|
    tokens = Attentive.tokenize(key, substitutions: false)
    possibilities = values.map { |value| Attentive.tokenize(value, substitutions: false) }
    value = possibilities.length == 1 ? possibilities[0] : Attentive::Phrase.new([Attentive::Tokens::AnyOf.new(key, possibilities, 0)])
    new_hash[tokens] = value
  end.freeze
end
      RUBY
    end

  end

end

task :default => :spec
