#!/usr/bin/env ruby

Marker_length = 4

def offset_length(line)
  offset = 0
  offset += 1 while not only_unique(line[offset...(offset + Marker_length)])
  offset + Marker_length
end


def only_unique(sequence)
  sequence.chars.uniq.length == sequence.length
end


puts ARGF.map {|line| offset_length(line.chomp)}

