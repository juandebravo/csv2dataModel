# To change this template, choose Tools | Templates
# and open the template in the editor.

class PlantumlHandler
  
  attr_accessor :file_name

  def initialize
    @uml = []
    @file_name = "uml_file.png"
  end

  # Generic method to insert a new line in the uml definition
  def add(text)
    @uml ||= []
    @uml.push text
  end

  # Create a new line defining a class
  # Sets the class as the current one
  def add_class(klass)
     @current_klass = klass
     add "class #{klass}"
  end

  # Create a new line defining a class attribute
  # In no klass is received, current_class is used
  def add_attribute(attr, klass = nil)
    klass.nil? and klass = @current_klass
    add "#{klass} : #{attr}"
  end

  # Create a new line defining an interface
  def add_interface(interface)
    @current_interface = interface
    add "interface #{interface}"
  end

  # Create a new line defining an interface method
  # In no interface is received, current_interface is used
  def add_method(method, parameters, output, interface = nil)
    interface.nil? and interface = @current_interface
    add "#{interface} : #{method} ( #{parameters.join(',')} ) : #{output.empty? ? "void" : output}"
  end

  def start_uml(file_name = nil)
    _file_name = file_name.nil? ? @file_name : file_name
    add("@startuml img/#{_file_name}")
  end

  def end_uml
    add("@enduml")
  end

  def write(file)
    File.open(file, 'w+') {|f|
      @uml.each{|line|
        f.write("#{line}\r\n")
      }
    }
  end

end
