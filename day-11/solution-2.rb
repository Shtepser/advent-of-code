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
      item = (@operation.call @items.shift)
      if item > 223092870
        item %= 223092870
      end
      result[@targets[item.divisible? @divisor]] << item
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


class Integer
  def divisible?(divisor)
    # p "#{self.digits.length}; checking #{divisor}"
    case divisor
    when 2
      divisible_by_2?
    when 3
      divisible_by_3?
    when 5
      divisible_by_5?
    when 7
      divisible_by_7?
    when 11
      divisible_by_11?
    when 13
      divisible_by_13?
    when 17
      divisible_by_17?
    when 19
      divisible_by_19?
    when 23
      divisible_by_23?
    else
      self % divisor == 0
    end
  end

  private

  def divisible_by_2?
    self.digits.first % 2 == 0
  end

  def divisible_by_3?
    self.digits.sum % 3 == 0
  end

  def divisible_by_5?
    [5, 0].include? self.digits.first
  end

  def divisible_by_7?
    num = self.dup
    until num <= 140 do
      decimals, ones = num.divmod 10
      num = decimals * 3 + ones
    end
    return num % 7 == 0
  end

  def divisible_by_11?
    return self % 11 == 0 if self <= 110
    first = self.digits.values_at(*(1..digits.length).step(2)).reject(&:nil?).sum
    second = self.digits.values_at(*(0..digits.length).step(2)).reject(&:nil?).sum
    return (first - second).abs.divisible? 11
  end

  def divisible_by_13?
    num = self.dup
    until num <= 130 do
      decimals, ones = num.divmod 10
      num = decimals + ones * 4
    end
    return num % 13 == 0
  end

  def divisible_by_17?
    num = self.dup
    until num <= 170 do
      decimals, ones = num.divmod 10
      num = (decimals - ones * 5).abs
    end
    return num % 17 == 0
  end

  def divisible_by_19?
    num = self.dup
    until num <= 190 do
      decimals, ones = num.divmod 10
      num = decimals + ones * 2
    end
    return num % 19 == 0
  end

  def divisible_by_23?
    num = self.dup
    until num <= 1000 do
      centuries, ones = num.divmod 100
      num = centuries + ones * 3
    end
    return num % 23 == 0
  end
end


class Array
  def mul
    inject {|p, c| p * c}
  end
end


if __FILE__ == $0
  data = ARGF.read.split "\n\n"
  circle = MonkeyCircle.new data.map {|data| build_monkey data}
  rounds = 10000
  rounds.times do |time|
    # puts "                    #{time}"
    circle.round
  end
  puts circle.monkeys.map(&:business).max(2).mul
end

