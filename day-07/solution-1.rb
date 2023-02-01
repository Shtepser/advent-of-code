#!/usr/bin/env ruby

class Directory

  attr_reader :path

  def initialize
    to_root
  end

  def up
    @path.sub!(/\w+\/$/, '')
  end

  def down(dir)
    @path << "#{dir}/"
  end

  def to_root
    @path = "/"
  end

  def paths
    @path.scan(/\w+\//).reduce(["/"]) {|result, item| result.push result[-1] + item}
  end
end


if __FILE__ == $0
  files = Hash.new(0)
  current_dir = Directory.new
  
  ARGF.each do |line|
    line.chomp!
    if line.start_with? "$ "
      line.delete_prefix! "$ "
      case line
      when "cd /"
        current_dir.to_root
      when "cd .."
        current_dir.up
      when /cd \w+/
        current_dir.down line[3..]
      end
    elsif not line.start_with? "dir"
      size, name = line.split
      current_dir.paths.each do |path|
        files[path] += size.to_i
      end
    end
  end
  puts files.filter {|key, value| value <= 100000}.values.sum
end

