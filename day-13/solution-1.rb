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

class Pair
  def initialize(left, right)
    @left = left
    @right = right
  end

  def pretty_print(pp)
    pp.text "<Pair #{@left} & #{@right}>"
  end

  def right_order?
    @left.lesser? @right
  end
end


if __FILE__ == $0
  lines = ARGF.readlines.map! {|line| line.chomp}
  pairs = []
  until lines.empty? do
    left, right = lines.shift(2).map {|line| Array.load(line)}
    pairs << Pair.new(left, right)
    lines.shift(1) unless lines.length == 0
  end
  sum = pairs.each_with_index.inject(0) do |memo, pair_with_ix|
    pair, ix = pair_with_ix
    ix += 1
    memo += ix if pair.right_order?
    memo
  end
  p sum
end

