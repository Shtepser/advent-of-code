#!/usr/bin/env ruby

total = 0


def item_priority(item)
  is_lower = /[[:lower:]]/.match? item
  shift = is_lower ? 1 : 27
  start = is_lower ? 'a' : 'A'
  shift + item.ord - start.ord
end



ARGF.each do |line|
  line.strip!
  first, second = line[..line.length / 2 - 1], line[line.length / 2..]
  common = (first.scan(/./) & second.scan(/./)).first
  total += item_priority(common)
end



puts total

