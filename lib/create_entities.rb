require 'line_values'
require 'plantuml_handler'
require 'csv_handler'
require 'entity'

if __FILE__ == $0

  PLANTUML_FOLDER = "/Users/jdbd/bin/"

  ORIGIN_FILE   = "Entities.csv"
  DEST_FILE     = "entities.txt"
  IMAGE_FILE    = "entities.png"

  HEADER_LINES    = 2

  # 1. load data
  csv_handler = CsvHandler.new(ORIGIN_FILE, ";", HEADER_LINES)
  data = csv_handler.read_file

  # 2.- convert CSV data into valid objects
  entities = csv_handler.get_entities(data)

  # 3.- generate file with valid plantUML format
  uml = PlantumlHandler.new
  uml.start_uml(IMAGE_FILE)

  entities.each{|entity|
    uml.add ""
    uml.add_class(entity.name)
    entity.attributes.each{|attribute|
      uml.add_attribute(attribute)
    }
  }
  
  uml.end_uml
  uml.write(DEST_FILE)

  `java -cp #{PLANTUML_FOLDER}/plantuml.jar -jar #{PLANTUML_FOLDER}/plantuml.jar #{DEST_FILE}`
end
