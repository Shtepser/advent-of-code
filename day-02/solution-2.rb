#!/usr/bin/env ruby

module Result
  WIN = 6
  DRAW = 3
  LOSE = 0
end


module Choice
  ROCK = 1
  PAPER = 2
  SCISSORS = 3
end

score = 0

ARGF.each do |line|
  opponent, result = line.split()
  case result
  when "X"
    score += Result::LOSE
    case opponent
    when "A"
      score += Choice::SCISSORS
    when "B"
      score += Choice::ROCK
    when "C"
      score += Choice::PAPER
    end
  when "Y"
    score += Result::DRAW
    case opponent
    when "A"
      score += Choice::ROCK
    when "B"
      score += Choice::PAPER
    when "C"
      score += Choice::SCISSORS
    end
  when "Z"
    score += Result::WIN
    case opponent
    when "A"
      score += Choice::PAPER
    when "B"
      score += Choice::SCISSORS
    when "C"
      score += Choice::ROCK
    end
  end
end

puts score

