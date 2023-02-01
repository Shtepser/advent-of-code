#!/usr/bin/env ruby

class Field

  def initialize(rocks)
    @pouring_point = [500, 0]
    calculate_positions(rocks)
    create_field
    add_solid_rocks(rocks)
    @full = false
  end

  def pretty_print(pp)
    translation = {:empty => '.', :start => '+', :rock => '#', :sand => 'o'}
    pp.text "Field:\n"
    @depth.times do |y|
      pp.text @field[y].map {|elem| translation[elem]}.join + "\n"
    end
  end

  def full?
    @full
  end

  def drop_sand
    return if full?
    sand = @pouring_point.dup
    while can_fall(*sand)
      sand = fall(*sand)
      if sand[1] >= @depth - 1
        @abyssed += 1
        return
      end
    end
    @full = sand == @pouring_point 
    @field[sand[1]][sand[0] - @x_start] = :sand
  end

  private

  def calculate_positions(rocks)
    min_x, max_x = rocks.flatten.select.with_index {|pos, ix| ix.even?}.minmax
    max_y = rocks.flatten.select.with_index {|pos, ix| ix.odd?}.max
    min_x -= max_y; max_x += max_y ; max_y += 1
    @x_start = min_x
    @width = max_x - min_x + 1
    @depth = max_y + 2
  end

  def create_field
    @field = Array.new(@depth) {Array.new(@width, :empty)}
    @field[@pouring_point[1]][@pouring_point[0] - @x_start] = :start
  end

  def add_solid_rocks(rocks)
    rocks.each do |line|
      first = line.shift
      until line.empty?
        second = line.shift
        if first[0] == second[0]
          x = first[0] - @x_start
          y_start, y_end = [first[1], second[1]].minmax
          (y_start..y_end).each {|y| @field[y][x] = :rock}
        else
          y = first[1]
          x_start, x_end = [first[0], second[0]].map {|pos| pos - @x_start}.minmax
          (x_start..x_end).each {|x| @field[y][x] = :rock}
        end
        first = second
      end
    (0..@width - 1).each {|x| @field[-1][x] = :rock}
    end
  end

  def can_fall(x, y)
    x -= @x_start
    @field[y + 1][(x - 1)..(x + 1)].any? {|elem| elem == :empty}
  end

  def fall(x, y)
    return [x, y + 1] if @field[y + 1][x - @x_start] == :empty
    return [x - 1, y + 1] if @field[y + 1][x - @x_start - 1] == :empty
    return [x + 1, y + 1]
  end

end

def read_rocks(lines)
  lines.map do |line|
    line.split(' -> ').map {|point| point.split(',').map &:to_i}
  end
end

if __FILE__ == $0
  rocks = read_rocks(ARGF.readlines.map &:chomp)
  field = Field.new(rocks)
  sands = 0
  until field.full?
    sands += 1
    field.drop_sand
  end
  puts sands
  # pp field
end

