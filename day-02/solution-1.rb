#!/usr/bin/env ruby

module Result
  WIN = 6
  DRAW = 3
  LOSE = 0
end


score = 0

ARGF.each do |line|
  opponent, you = line.split()
  case you
  when "X"
    score += 1
    case opponent
    when "A"
      score += Result::DRAW
    when "B"
      score += Result::LOSE
    when "C"
      score += Result::WIN
    end
  when "Y"
    score += 2
    case opponent
    when "A"
      score += Result::WIN
    when "B"
      score += Result::DRAW
    when "C"
      score += Result::LOSE
    end
  when "Z"
    score += 3
    case opponent
    when "A"
      score += Result::LOSE
    when "B"
      score += Result::WIN
    when "C"
      score += Result::DRAW
    end
  end
end

puts score

