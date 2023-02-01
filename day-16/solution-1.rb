#!/usr/bin/env ruby
require 'set'

class TunnelsSystem
  def initialize(valves)
    @valves = valves.map {|v| [v.name, v]}.to_h
    @current = :AA
  end

  def routes(depth)
    routes = @valves[@current].tunnels.map {|t| [t]}
    (depth - 1).times do |time|
      puts "#{time + 1}, #{routes.length}"
      routes = routes.map do |route|
        @valves[route.last].tunnels.map {|t| route.dup.append t}
      end.flatten(1)
    end
    routes
  end

  def way_to(valve)
    raise "No such valve: #{valve}" unless @valves.include? valve
    routes = [[@current]]
    until routes.any? {|route| route.include? valve}
      routes = routes.flat_map do |route|
        @valves[route.last].tunnels.map \
          {|tunnel| route.dup.append(tunnel)}
      end
    end
    routes.select {|route| route.include? valve}.first.drop(1)
  end

  def way(from, to)
    raise "No such valve: #{to}" unless @valves.include? to
    routes = [[from]]
    until routes.any? {|route| route.include? from}
      routes = routes.flat_map do |route|
        @valves[route.last].tunnels.map \
          {|tunnel| route.dup.append(tunnel)}
      end
    end
    routes.select {|route| route.include? from}.first.drop(1)
  end

  def score(valve, minutes_remain, exclude=nil)
    valve = @valves[valve]
    return 0 if valve.open?
    way_length = way_to(valve.name).length
    remaining_minutes = minutes_remain - way_length - 1
    self_score = valve.rate * remaining_minutes
    self_score + neighbors_score
  end

  def move_to(valve)
    raise "No direct tunnel from #{@current} to: #{valve}" \
      unless @valves[@current].tunnels.include? valve
    @current = valve
  end

  def closed_valves
    @valves.values.filter {|valve| valve.closed? && valve.rate != 0}
  end

  def current
    @valves[@current]
  end

  # def show(pp)
  #   pp.text "Current: #{@current.name}\n"
  #   @valves.each do |name, valve|
  #     pp.text "#{valve.name}, distance = #{way_to(name).length}, score = #{score(name).round(2)}\n"
  #   end
  # end
end

class Valve
  include Comparable

  attr_reader :name, :rate

  def initialize(name, rate, tunnels_to)
    @name = name
    @rate = rate
    @tunnels = tunnels_to.map &:to_sym
    @open = false
  end

  def self.read(string)
    match = string.match(/Valve\s(?<name>\w+)\shas\sflow\srate=(?<rate>\d+);\s
                         tunnels?\sleads?\sto\svalves?\s(?<tunnels>((\w+)(,\s)?)+)
                         /x)
    Valve.new(match[:name].to_sym, match[:rate].to_i, match[:tunnels].split(', '))
  end

  def tunnels
    @tunnels.dup
  end

  def open?
    @open.dup
  end

  def open
    @open = true
  end

  def closed?
    !open?
  end

  def <=>(other)
    return rate <=> other.rate
  end

  def to_s
    "<Valve #{@name}: rate=#{@rate}, tunnels to #{@tunnels.join(', ')}>"
  end

  def pretty_print(pp)
    pp.text to_s
  end
end

def main
  tunnels = TunnelsSystem.new(ARGF.map {|line| Valve.read line.chomp})
  minutes_remain = 30
  released_pressure = 0
  # pp tunnels.routes(20).length
  while minutes_remain > 0
    break if tunnels.closed_valves.empty?
    # pp tunnels
    next_valve = tunnels.closed_valves.sort_by {|v| tunnels.score(v.name, minutes_remain)}.last
    if tunnels.current == next_valve
      puts "Minute #{31 - minutes_remain}. Opening valve #{tunnels.current.name.to_s}"
      released_pressure += tunnels.current.rate * (minutes_remain - 1)
      tunnels.current.open
      puts "Released #{tunnels.current.rate * (minutes_remain - 1)} pressure"
    else
      route = tunnels.way_to(next_valve.name)
      tunnels.move_to(route.first)
      puts "Minute #{31 - minutes_remain}. Moving to valve #{next_valve.name.to_s}"
    end
    minutes_remain -= 1
  end
  puts released_pressure
end

main if __FILE__ == $PROGRAM_NAME

