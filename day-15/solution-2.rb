#!/usr/bin/env ruby
require 'set'

MIN, MAX = 0, 4000000

class Field
  def initialize(sensors)
    @sensors = Set.new sensors.map {|sensor| Sensor.new(*sensor)}
  end

  def find_beacon(min_x, max_x, min_y, max_y)
    (min_y..max_y).each do |y|
      intervals = @sensors.map do |s|
        h = (s.pos[1] - y).abs
        w = s.distance - h
        w >= 0 ? [s.pos[0] - w, s.pos[0] + w] : nil
      end
      intervals.compact!.reject! {|start, finish| finish < MIN || start > MAX}
      intervals.sort!
      filled = MIN - 1
      until intervals.empty? or filled >= MAX
        start, finish = intervals.shift
        if start > filled + 1
          return [filled + 1, y]
        end
        filled = [filled, finish].max
      end
      if filled < MAX
        return [MAX, y]
      end
    end
  end
end

class Sensor
  attr_reader :pos, :distance

  def initialize(pos, beacon_pos)
    @pos = pos.dup
    @beacon = beacon_pos.dup
    @distance = Math.manhattan_distance(*@pos, *@beacon)
  end

  def pretty_print(pp)
    pp.text "<Sensor at (#{@pos[0]}, #{@pos[1]}); distance = #{@distance}>"
  end

  def square
    min_x, max_x = @pos[0] - @distance, @pos[0] + @distance
    min_y, max_y = @pos[1] - @distance, @pos[1] + @distance
    [min_x, max_x, min_y, max_y]
  end

  def cover?(x, y)
    Math.manhattan_distance(*@pos, x, y) <= Math.manhattan_distance(*@pos, *@beacon)
  end

  def block?(x, y)
    [x, y] == @pos || [x, y] == @beacon
  end
end

module Math
  def self.manhattan_distance(x_0, y_0, x_1, y_1)
    (x_0 - x_1).abs + (y_0 - y_1).abs
  end
end


if __FILE__ == $PROGRAM_NAME
  sensors = ARGF.map do |line|
    line.scan(/-?\d+/).map(&:to_i).each_slice(2).to_a
  end
  field = Field.new(sensors)
  beacon = field.find_beacon(MIN, MAX, MIN, MAX)
  puts beacon
  puts beacon[0] * MAX + beacon[1]
end

