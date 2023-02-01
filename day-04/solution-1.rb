#!/usr/bin/env ruby

total = 0


ARGF.each do |line|
  first, second = line.strip.split(',').map {|range| range.split('-').map {|num| Integer(num)}}
  if first[0] <= second[0] && first[1] >= second[1] ||
first[0] >= second[0] && first[1] <= second[1] then
    total += 1
  end
end


puts total

