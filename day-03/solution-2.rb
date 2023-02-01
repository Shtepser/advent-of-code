#!/usr/bin/env ruby


def item_priority(item)
  is_lower = /[[:lower:]]/.match? item
  shift = is_lower ? 1 : 27
  start = is_lower ? 'a' : 'A'
  shift + item.ord - start.ord
end


total = 0
group = []
Group_size = 3


ARGF.each do |line|
  line.strip!
  group.append(line)
  if group.length == Group_size
    common_items = group.first.scan(/./)
    group[1..].each do |elf|
      common_items = common_items & elf.scan(/./)
    end
    total += item_priority(common_items.first)
    group.clear
  end
end


puts total

