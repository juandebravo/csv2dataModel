
module Csv2dataModel
  
  module Handlers

    class PlantumlHandler

      attr_accessor :file_name

      def initialize(file_name = nil)
        @uml = []
        @file_name = file_name.nil? ? "uml_file.png" : file_name
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
      # If no klass is received, current_class is used
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

      # Initial line to start UML file
      # file_name: the file where the image will be generated
      def start_uml(file_name = nil)
        _file_name = file_name.nil? ? @file_name : file_name
        add("@startuml #{_file_name}")
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

      def generate_image(plantuml_folder, definition)
        `java -cp #{plantuml_folder}/plantuml.jar -jar #{plantuml_folder}/plantuml.jar #{definition}`
      end

    end

  end

end
