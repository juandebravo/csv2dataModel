require 'line_values'
require 'plantuml_handler'
require 'excel_handler'
require 'interface'

if __FILE__ == $0

  PLANTUML_FOLDER = "/Users/jdbd/bin/"

  ORIGIN_FILE     = "JajahInterfaces.csv"
  DEST_FILE       = "jajah_interfaces.txt"
  IMAGE_FILE      = "jajah_interfaces.png"

  HEADER_LINES    = 4

  excel_handler = ExcelHandler.new(ORIGIN_FILE, ";", HEADER_LINES)

  # 1. load data
  data = excel_handler.read_file

  # 2.- convert CSV data into valid objects
  interfaces = excel_handler.get_interfaces(data)

  # 3.- generate file with valid plantUML format
  uml = PlantumlHandler.new
  uml.start_uml(IMAGE_FILE)

  interfaces.each{|interface|
    uml.add ""
    uml.add "interface #{interface.name}"
    interface.methods.each{|method|
      uml.add "#{interface.name} : #{method.name} ( #{method.parameters.join(',')} ) : #{method.output.empty? ? "void" : method.output}"
    }
  }

  uml.end_uml
  uml.write(DEST_FILE)

  `java -cp #{PLANTUML_FOLDER}/plantuml.jar -jar #{PLANTUML_FOLDER}/plantuml.jar #{DEST_FILE}`
end
