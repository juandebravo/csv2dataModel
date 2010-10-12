require 'line_values'
require 'plantuml_handler'
require 'csv_handler'
require 'interface'

if __FILE__ == $0

  PLANTUML_FOLDER = "/Users/jdbd/bin/"

  ORIGIN_FILE     = "Interfaces.csv"
  DEST_FILE       = "interfaces.txt"
  IMAGE_FILE      = "interfaces.png"

  HEADER_LINES    = 4

  csv_handler = CsvHandler.new(ORIGIN_FILE, ";", HEADER_LINES)

  # 1. load data
  data = csv_handler.read_file

  # 2.- convert CSV data into valid objects
  interfaces = csv_handler.get_interfaces(data)

  # 3.- generate file with valid plantUML format
  uml = PlantumlHandler.new
  uml.start_uml(IMAGE_FILE)

  interfaces.each{|interface|
    uml.add ""
    uml.add_interface(interface.name)
    interface.methods.each{|method|
      uml.add_method(method.name, method.parameters, method.output)
    }
  }

  uml.end_uml
  uml.write(DEST_FILE)

  `java -cp #{PLANTUML_FOLDER}/plantuml.jar -jar #{PLANTUML_FOLDER}/plantuml.jar #{DEST_FILE}`
end
