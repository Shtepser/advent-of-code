#!/usr/bin/env ruby
require 'json'

class Array
  def self.load(string)
    JSON.parse string
  end

  def lesser?(other)
    return lesser?([other]) unless other.is_a? Array
    ix = 0
    stop = [length - 1, other.length - 1].max
    while ix <= stop do
      return false if ix >= other.length
      return true if ix >= length
      result = self[ix].lesser? other[ix]
      return result unless result.nil?
      ix += 1
    end
    nil
  end
end

class Integer
  def lesser?(other)
    return [self].lesser? other if other.is_a? Array
    return nil if self == other
    self < other
  end
end


if __FILE__ == $0
  lines = ARGF.readlines.map! {|line| line.chomp}
  packets = [[[2]], [[6]]]
  until lines.empty? do
    left, right = lines.shift(2).map {|line| Array.load(line)}
    packets << left << right
    lines.shift(1) unless lines.length == 0
  end
  packets.sort! {|a, b| (a.lesser? b) ? -1 : 1}
  puts (packets.index([[2]]) + 1) * (packets.index([[6]]) + 1)
end

