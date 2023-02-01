#!/usr/bin/env ruby


module ImportantCycles
  START = 20
  STEP = 40
end


class CPU
  attr_reader :sum

  def initialize
    @registers = {:x => 1}
    @current_cycle = 1
    @sum = 0
    @important_cycle = ImportantCycles::START
  end

  def execute(command, *args)
    case command
    when :addx
      addx(args[0])
    when :noop
      noop
    end
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
    if @current_cycle == @important_cycle
      @sum += (@registers[:x] * @current_cycle)
      @important_cycle += ImportantCycles::STEP
      pp self
    end
    @current_cycle += 1
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

  puts cpu.sum
end

