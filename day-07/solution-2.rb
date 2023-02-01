#!/usr/bin/env ruby

Total_space = 70000000
Required_space = 30000000

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
  dirs_size = Hash.new(0)
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
        dirs_size[path] += size.to_i
      end
    end
  end

  free_space = Total_space - dirs_size["/"]

  puts dirs_size.values.filter {|size| free_space + size >= Required_space}.min

end

