
#
# This class is used to load and parse and Excel and generate objects with
# Interface and Entity information
#
class ExcelHandler

  def initialize(path_to_file = nil, separator = nil, omit_lines = 0)
    @path_to_file = path_to_file
    @separator = separator
    @omit_lines = omit_lines
  end

  def read_file(path_to_file = nil, separator = nil, omit_lines = -1)
    lines = Array.new

    path_to_file = path_to_file.nil? ? @path_to_file : path_to_file
    
    separator = separator.nil? ? @separator : separator

    omit_lines = omit_lines >= 0 ? omit_lines : @omit_lines
    
    File.open(path_to_file, "r") {|file|
      file.each_line{ |line|
        if separator.nil?
          lines << line
        else
          lines << line.split(separator)
        end
      }
    }
    lines.shift(omit_lines)
    lines
  end

  #
  # This method converts the CSV loaded file into an array of Interface objects.
  # Each interface has defined a list of methods.
  #
  def get_interfaces(data)

    interfaces = Array.new
    @interface = Interface.new

    data.each{|value|
      values = get_values(value)

      if values.nil?
        next
      end

      # New interface
      unless values.nil? || values.interface.eql?("")

        unless @interface.empty?
          interfaces << @interface
        end

        @interface = Interface.new

        2.times {
          puts ""
        }
        puts "-----------------------"

        @interface.name = values.interface.gsub(/[^a-zA-Z0-9]/,'')

        puts "Interface: #{@interface.name}"

        # In the same line of new Interface, probably a method is defined
        unless values.method.eql?("")
          puts "     Method: #{values.method}"
          @method = MethodDef.new
          @method.name = values.method
          @method.output = values.output
        end

        unless values.parameter.nil? || values.parameter.eql?("")
          puts "            Parameter: #{values.parameter}"
          @method.add_parameter values.parameter
        end
      else # Same interface
        # New method
        unless values.method.eql?("")
          @interface.add_method(@method)
          @method = MethodDef.new
          @method.name = values.method
          @method.output = values.output
          puts "     Method: #{@method.name}"
        else # get parameter for current method
          unless values.parameter.nil? || values.parameter.eql?("")
            puts "            Parameter: #{values.parameter}"
            @method.add_parameter values.parameter
          end
        end
      end
    }
    interfaces << @interface
    interfaces
  end

  #
  # This method converts the CSV loaded file into an array of Entity objects.
  # Each entity has defined a list of attributes.
  #
  def get_entities(data)

    entities = Array.new
    attributes ||= []

    @entity = Entity.new

    data.each{|value|
      values = get_values(value)

      if values.nil?
        next
      end

      # New Entity
      unless values.nil? || values.entity.nil? || values.entity.eql?("")
        # In the first iteration there's no previous entity
        unless @entity.empty?
          entities << @entity
        end

        2.times {
          puts ""
        }

        puts "-----------------------"
        puts "Entity: #{values.entity}"


        # Start the new entity
        @entity = Entity.new
        @entity.name = values.entity.gsub(/[^a-zA-Z0-9]/,'')

        # In the same line of new Interface, probably an attribute is defined
        unless values.attribute.eql?("")
          # Add new attribute
          puts "    Attribute #{values.attribute}"
          @entity.add_attribute values.attribute
        end

      else # Same entity
        unless values.attribute.eql?("")
          # Add new attribute
          puts "    Attribute #{values.attribute}"
          @entity.add_attribute values.attribute
        end
      end
    }
    # Add last entity
    entities << @entity
    entities
  end

  private

  # Convert a line into an object with the data required
  def get_values(line)
    unless line.instance_of?(Array)
      line = line.split(";")
    end
    if line.length < 3
      return nil
    end
    return LineValues.new(line)
  end

end
