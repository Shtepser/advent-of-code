#!/usr/bin/env ruby


class CPU
  attr_reader :crt

  def initialize
    @registers = {:x => 1}
    @current_cycle = 1
    @crt = CRT.new
  end

  def execute(command, *args)
    case command
    when :addx
      addx(args[0])
    when :noop
      noop
    end
  end

  def x
    @registers[:x].dup
  end

  def cycle
    @current_cycle.dup
  end

  def pretty_print(pp)
    registers = @registers.each_pair.map {|k, v| "#{k}=#{v}"}.join('; ')
    pp.text "<CPU: cycle #{@current_cycle}; #{registers}>"
  end

  private

  def addx(v)
    duration = 2
    duration.times {next_cycle}
    @registers[:x] += v
  end

  def noop
    duration = 1
    duration.times {next_cycle}
  end

  def next_cycle
    @crt.next x
    @current_cycle += 1
  end
end


class CRT
  LINE_LENGTH = 40

  def initialize
    @screen = ['']
  end

  def next(x)
    line = @screen.last
    index = line.length
    line << ((index - x).abs <= 1 ? '#' : '.')
    @screen << '' if line.length == LINE_LENGTH
  end

  def screen
    @screen.join("\n")
  end
end


if __FILE__ == $0
  cpu = CPU.new
  ARGF.each do |line|
    line.chomp!
    case line
    when "noop"
      cpu.execute :noop
    when /^addx (-?\d+)$/
      v = line.match(/^addx (-?\d+)$/).captures.first.to_i
      cpu.execute :addx, v
    end
  end

  puts cpu.crt.screen
end

