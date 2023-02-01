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
  def initialize(heights, start, finish)
    @heights = heights
    @start = start
    @finish = finish
  end

  def accessible_from(x, y)
    return unless correct_index?(x, y)
    nearest(x, y).filter {|x_1, y_1| can_move(x_1, y_1, x, y)}
  end

  def can_access(x, y)
    return unless correct_index?(x, y)
    nearest(x, y).filter {|x_1, y_1| can_move(x, y, x_1, y_1)}
  end

  def way_length
    moves = 0
    accessible = Set.new << @start.dup
    visited = Set.new
    until accessible.include? @finish
      visited |= accessible
      accessible = accessible.inject(Set.new) do |memo, pos|
        memo + can_access(*pos)
      end
      accessible -= visited
      moves += 1
    end
    moves
  end

  def self.load(lines)
    start, finish = nil, nil
    lines = lines.each_with_index.map do |line, line_ix|
      line.chomp!
      line = line.chars.map {|c| c.to_sym}
      if line.include? :S
        start = [line.index(:S), line_ix]
        line.replace_element(:S, :a)
      end
      if line.include? :E
        finish = [line.index(:E), line_ix]
        line.replace_element(:E, :z)
      end
      line
    end
    Heights.new lines, start, finish
  end

  private

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
end

if __FILE__ == $0
  heights = Heights.load ARGF.readlines
  p heights.way_length
end

