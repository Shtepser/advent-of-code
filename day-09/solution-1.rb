#!/usr/bin/env ruby
require 'set'

class Rope
  attr_accessor :head, :tail

  def initialize
    @head = [0, 0]
    @tail = [0, 0]
    @positions = Set.new
    record_tail_position
  end

  def move(direction)
    move_head(direction)
    move_tail
    record_tail_position
  end

  def uniq
    @positions.count
  end

  private

  def move_head(direction)
    case direction
    when :up
      @head[1] += 1
    when :down
      @head[1] -= 1
    when :left
      @head[0] -= 1
    when :right
      @head[0] += 1
    end
  end

  def move_tail
    if (@head[0] - @tail[0]).abs <= 1 && (@head[1] - @tail[1]).abs <= 1
      return
    end
    @tail[0] += (@head[0] - @tail[0] <=> 0)
    @tail[1] += (@head[1] - @tail[1] <=> 0)
  end

  def record_tail_position
    @positions.add(@tail.dup)
  end
end

if __FILE__ == $0
  rope = Rope.new
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
    steps.times do ||
      rope.move direction
    end
  end
end

puts rope.uniq

