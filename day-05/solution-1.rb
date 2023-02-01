#!/usr/bin/env ruby


reading_crates = true
crates = []

ARGF.each do |line|
  if line.match? /^\s+$/
    reading_crates = false
  elsif reading_crates and not (line.include? '[')
    next
  elsif reading_crates 
    (1..line.length).step(4).with_index do |ix, crate|
      item = line[ix]
      if crates.length <= crate
        crates.append []
      end
      unless item == ' '
        crates[crate].insert(0, item)
      end
    end
  else
    params = line.match /move (?<count>\d+) from (?<from>\d) to (?<to>\d)/
    items = crates[params[:from].to_i - 1].pop(params[:count].to_i).reverse
    crates[params[:to].to_i - 1] += items
  end
end

puts crates.map {|crate| crate[-1]}.join('')


