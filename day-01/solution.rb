#!/usr/bin/env ruby
elves = []
current = 0

lines = File.readlines("input.txt")

ARGF.each do |line, ix|
  line.strip!
  unless line.empty?
    current += Integer(line)
  else
    elves.append(current)
    current = 0
  end
end
elves.append(current)


puts elves.max(3).sum

