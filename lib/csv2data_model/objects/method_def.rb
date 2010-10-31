
module Csv2dataModel::Objects

  class MethodDef
    attr_accessor :name
    attr_accessor :parameters
    attr_accessor :output
    attr_accessor :verb
    attr_accessor :uri
    attr_accessor :description

    def initialize(*args)
      unless args.nil? || args.empty?
        @name       = *args[0]
        @parameters = *args[1]
        @output     = *args[2]
        @description= *args[3]
      else
        @name       = nil
        @parameters = []
        @output     = nil
        @description= nil
      end
    end

    def add_parameter(parameter)
      @parameters ||= []
      @parameters.push parameter
    end

    def set_parameters(parameters)
      @parameters = parameters
    end

    def empty?
      @name.nil? || @name.strip.empty?
    end
  end
end
