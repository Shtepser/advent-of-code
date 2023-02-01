#!/usr/bin/env ruby
require 'set'

ROW = 2000000

class Field
  def initialize(sensors)
    @sensors = Set.new sensors.map {|sensor| Sensor.new(*sensor)}
  end

  def filled_positions(row)
    min_x, max_x = @sensors.reduce([]) {|m, s| m.union s.square.first(2).flatten}.minmax
    positions = (min_x..max_x)
    puts "Positions: #{positions.count}"
    positions.reject {|x| @sensors.any? {|sensor| sensor.block?(x, row)}} \
             .filter {|x| @sensors.any? {|sensor| sensor.cover?(x, row)}}
  end
end

class Sensor
  def initialize(pos, beacon_pos)
    @pos = pos.dup
    @beacon = beacon_pos.dup
    @distance = Math.manhattan_distance(*@pos, *@beacon)
  end

  def pretty_print(pp)
    pp.text "<Sensor at (#{@pos[0]}, #{@pos[1]}); nearest beacon at (#{@beacon[0]}, #{@beacon[1]})>"
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
    line.scan(/\d+/).map(&:to_i).each_slice(2).to_a
  end
  field = Field.new(sensors)
  puts "Sensors: #{sensors.count}"
  puts field.filled_positions(ROW).count
end

