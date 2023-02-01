#!/usr/bin/env ruby


class Monkey
  def initialize(items, operation, divisor, targets)
    @items = items
    @operation = operation
    @divisor = divisor
    @targets = targets
    @items_inspected = 0
  end

  def business
    @items_inspected
  end

  def inspect_items
    result = {@targets[true] => [], @targets[false] => []}
    until @items.empty? do
      item = (@operation.call @items.shift) / 3
      result[@targets[item.modulo(@divisor).zero?]] << item
      @items_inspected += 1
    end
    result
  end

  def add(items)
    @items += items
  end
end

class MonkeyCircle
  attr_reader :monkeys

  def initialize(monkeys)
    @monkeys = monkeys
  end

  def round
    @monkeys.each do |monkey|
      monkey.inspect_items.each_pair {|target, items| @monkeys[target].add items}
    end
  end
end


def parse_items(items)
  items.strip.scan(/\d+/).map(&:to_i)
end

def parse_operation(operation)
  operation = operation.match(/^ *Operation: (.*)$/).captures.first
  lambda {|old| eval operation}
end

def parse_divisor(test)
  test.match(/^ *Test: divisible by (\d+)$/).captures.first.to_i
end

def parse_targets(if_true, if_false)
  targets = (if_true + if_false).scan(/\d/).map(&:to_i)
  [true, false].zip(targets).to_h
end

def build_monkey(input)
  header, items, operation, test, if_true, if_false = input.split "\n"
  items = parse_items items
  operation = parse_operation operation
  divisor = parse_divisor test
  targets = parse_targets if_true, if_false
  Monkey.new items, operation, divisor, targets
end


class Array
  def mul
    inject {|p, c| p * c}
  end
end


if __FILE__ == $0
  data = ARGF.read.split "\n\n"
  circle = MonkeyCircle.new data.map {|data| build_monkey data}
  rounds = 20
  rounds.times do
    circle.round
  end
  puts circle.monkeys.map(&:business).max(2).mul
end

