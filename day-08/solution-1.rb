#!/usr/bin/env ruby

total = 0


map = []


ARGF.each do |line|
  line.chomp!
  map.push line.chars.map {|i| i.to_i}
end


map.each_with_index do |row, i|
  row.each_with_index do |tree, j|
    if i == 0 || j == 0 || i == map.length - 1 || j == row.length - 1
      total += 1
      next
    end
    left = row[...j]
    right = row[(j + 1)...]
    top = map[...i].map {|row| row[j]}
    bottom = map[(i + 1)...].map {|row| row[j]}

    if [left, right, top, bottom].any? {|seq| seq.all? {|other| other < tree}}
      total += 1
    end
  end  
end

puts total

