#!/usr/bin/env ruby


def viewing(trees, height)
  trees.each_index.select {|ix| trees[...ix].all? {|tree| tree < height}}.count
end


max_score = 0


map = []


ARGF.each do |line|
  line.chomp!
  map.push line.chars.map {|i| i.to_i}
end


map.each_with_index do |row, i|
  row.each_with_index do |tree, j|
    left = row[...j].reverse
    right = row[(j + 1)...]
    top = map[...i].map {|row| row[j]}.reverse
    bottom = map[(i + 1)...].map {|row| row[j]}

    scores = [left, right, top, bottom].map {|trees| viewing(trees, tree)}
    score = scores.reduce {|total, score| total *= score}

    max_score = score if score > max_score

  end  
end

puts max_score

