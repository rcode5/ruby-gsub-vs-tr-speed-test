#!/usr/bin/env ruby

require 'benchmark'
require 'byebug'
require 'faker'

class Replacer
  class << self
    def with_gsub(s)
      s.gsub(/\s+/, ' ')
    end

    def with_tr_s(s)
      s.tr_s(' ', ' ')
    end
  end
end


NUM_RUNS = 100000

def random_string(num_words)
  Faker::Lorem.words(number: num_words).reduce do |word, memo|
    memo + ' ' * rand(10) + word
  end
end

  s = random_string(10)
puts "*** Replacing all multiple spaces from \"#{s}\""
Benchmark.bm do |x|

  methods =  %i( with_gsub with_tr_s )

  tests = methods.map { |method| Replacer.send(method,s) }
  raise "Methods don't do the same thing" unless tests.all? { |t| t == tests.first }
  
  methods.each do |method|
    x.report(method) do
      for i in 1..NUM_RUNS
        Replacer.send(method, s) # matches
      end
    end
  end

  
end
