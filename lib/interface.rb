require 'method_def'

class Interface
  attr_accessor :name
  attr_accessor :methods

  def initialize(*args)
    unless args.nil? || args.empty?
      @name = *args[0]
      @methods = *args[1]
    else
      @name = nil
      @methods = []
    end
  end

  def add_method(method)
    @methods ||= []
    @methods.push method
  end

  def set_methods(methods)
    @methods = methods
  end

  def empty?
    @name.nil? || @name.strip.empty?
  end

  def to_s
    methods.each{|method|
      puts "\tMethod: #{method.name}"
      puts "\t\tOutput: #{method.output}"
      method.parameters.each{|parameter|
        puts "\t\t\tParameter: #{parameter}"
      }
    }
  end
end
