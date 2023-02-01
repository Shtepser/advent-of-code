#!/usr/bin/env ruby
require 'set'

class Rope
  attr_accessor :head, :tail

  def initialize(length)
    @head = Knot.new
    @tail = @head
    (length - 1).times do
      knot = Knot.new
      @tail.set_tail knot
      @tail = knot
    end
    @positions = Set.new
    record_tail_position
  end

  def move(direction)
    case direction
    when :up
      @head.move(0, 1)
    when :down
      @head.move(0, -1)
    when :left
      @head.move(-1, 0)
    when :right
      @head.move(1, 0)
    end
    record_tail_position
  end

  def uniq
    @positions.count
  end

  def record_tail_position
    @positions.add @tail.pos
  end
end


class Knot

  def initialize
    @pos = [0, 0]
    @tail = nil
  end

  def set_tail(knot)
    @tail = knot
  end

  def move(dx, dy)
    move_self(dx, dy)
    move_tail
  end

  def pos
    @pos.dup
  end

  private

  def move_self(dx, dy)
    @pos[0] += dx
    @pos[1] += dy
  end

  def move_tail
    return if @tail.nil?
    return if (@pos[0] - @tail.pos[0]).abs <= 1 && (@pos[1] - @tail.pos[1]).abs <= 1
    dx = (@pos[0] - @tail.pos[0] <=> 0)
    dy = (@pos[1] - @tail.pos[1] <=> 0)
    @tail.move(dx, dy)
  end
end


if __FILE__ == $0
  rope = Rope.new(10)
  ARGF.each do |line|
    line.chomp!
    direction, steps = line.split
    direction = case direction
                when "R"
                  :right
                when "U"
                  :up
                when "L"
                  :left
                when "D"
                  :down
                end
    steps = steps.to_i
    steps.times do 
      rope.move direction
    end
  end
  puts rope.uniq
end

