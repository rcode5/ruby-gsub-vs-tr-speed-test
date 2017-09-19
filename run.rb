#!/usr/bin/env ruby

require 'benchmark'
require 'byebug'
if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.4.0')
  require 'active_support/core_ext/enumerable'
end

class Matcher
  class << self
    def match_without_case(s1, s2)
      s1.downcase == s2.downcase
    end

    def match_exact(s1, s2)
      s1 == s2
    end

    def match_regex_symbol(s1, s2)
      s1 =~ /^#{s2}$/i
    end

    def match_regex_with_downcase(s1, s2)
      s1.downcase =~ /^#{s2.downcase}$/
    end
  end
end


NUM_RUNS = 50000

def random_string(length)
  (('A'..'Z').to_a + ('a'..'z').to_a).flatten.sample(length).join
end

Benchmark.bm do |x|
  s = random_string(20)
  %i( match_exact match_without_case match_regex_symbol  match_regex_with_downcase ).each do |method|
    x.report(method) do
      for i in 1..NUM_RUNS
        Matcher.send(method, s, s) # matches
        Matcher.send(method, s, random_string(20)) # does not match
      end
    end
  end
end
