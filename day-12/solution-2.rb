#!/usr/bin/env ruby
require 'set'

class Array
  def replace_element(which, with)
    pos = index(which)
    return if pos.nil?
    self[pos] = with
  end
end


class Heights
  attr_reader :finish

  def initialize(heights, finish)
    @heights = heights
    @finish = finish
    @cache = {}
  end

  def way_length(from, to)
    calculate_ways(*to) if @cache.empty? or @cache[to].empty?
    @cache[to][from]
  end

  def with_elevation(elevation)
    indexes = (0...@heights.first.length).to_a.product (0...@heights.length).to_a
    indexes.filter {|x, y| @heights[y][x] == elevation}
  end

  def self.load(lines)
    finish = nil
    lines = lines.each_with_index.map do |line, line_ix|
      line.chomp!
      line = line.chars.map {|c| c.to_sym}
      if line.include? :S
        line.replace_element(:S, :a)
      end
      if line.include? :E
        finish = [line.index(:E), line_ix]
        line.replace_element(:E, :z)
      end
      line
    end
    Heights.new lines, finish
  end

  private

  def calculate_ways(x, y)
    @cache[[x, y]] = cache = {}
    moves = 0
    steps = Set.new << [x, y]
    until steps.empty?
      steps.reject! {|pos| cache.include? pos and cache[pos] <= moves}
      steps.each {|pos| cache[pos] = moves}
      steps = steps.inject(Set.new) {|memo, pos| memo + accessible_from(*pos)}
      moves += 1
    end
  end

  def correct_index?(x, y)
    x.between?(0, @heights.first.length - 1) \
      and y.between?(0, @heights.length - 1)
  end

  def nearest(x, y)
    nearest_x, nearest_y = [x - 1, x, x + 1], [y - 1, y, y + 1]
    nearest_x.product(nearest_y).filter do |x_1, y_1|
      correct_index?(x_1, y_1) \
        and [x_1, y_1] != [x, y] \
        and (x_1 - x) * (y_1 - y) == 0
    end
  end

  def can_move(x_from, y_from, x_to, y_to)
    from = @heights[y_from][x_from]
    to = @heights[y_to][x_to]
    return to.to_s.ord - from.to_s.ord <= 1
  end
  
  def accessible_from(x, y)
    return unless correct_index?(x, y)
    nearest(x, y).filter {|x_1, y_1| can_move(x_1, y_1, x, y)}
  end

  def can_access(x, y)
    return unless correct_index?(x, y)
    nearest(x, y).filter {|x_1, y_1| can_move(x, y, x_1, y_1)}
  end
end

if __FILE__ == $0
  heights = Heights.load ARGF.readlines
  starts = heights.with_elevation(:a)
  p starts.length
  ways = starts.map {|pos| heights.way_length(pos, heights.finish)}
  ways.reject! {|e| e.nil?}
  p ways.min
end

