module Csv2dataModel::Objects
  
  class Entity
    attr_accessor :name
    attr_accessor :attributes

    def initialize(*args)
      unless args.nil? || args.empty?
        @name = *args[0]
        @attributes = *args[1]
      else
        @name = nil
        @attributes = []
      end
    end

    def add_attribute(attribute)
      @attributes ||= []
      @attributes.push attribute
    end

    def set_attributes(attributes)
      @attributes = attributes
    end

    def empty?
      @name.nil? || @name.strip.empty?
    end
  end
end
