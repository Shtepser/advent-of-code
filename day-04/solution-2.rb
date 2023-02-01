#!/usr/bin/env ruby


def to_interval(start, end_)
  (start..end_).to_a
end


total = 0

ARGF.each do |line|
  first, second = line.strip.split(',').map \
    {|range| range.split('-').map \
     {|num| Integer(num)}}
  first, second = to_interval(*first), to_interval(*second)
  unless (first.intersection second).empty?
    total += 1
  end
end


puts total

