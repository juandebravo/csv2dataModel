require 'line_values'
require 'plantuml_handler'
require 'excel_handler'
require 'entity'

if __FILE__ == $0

  PLANTUML_FOLDER = "/Users/jdbd/bin/"

  ORIGIN_FILE   = "JajahEntities.csv"
  DEST_FILE     = "jajah_entities.txt"
  IMAGE_FILE    = "jajah_entities.png"

  HEADER_LINES    = 2

  excel_handler = ExcelHandler.new(ORIGIN_FILE, ";", HEADER_LINES)

  # 1. load data
  data = excel_handler.read_file

  # 2.- convert CSV data into valid objects
  entities = excel_handler.get_entities(data)

  # 3.- generate file with valid plantUML format
  uml = PlantumlHandler.new
  uml.start_uml(IMAGE_FILE)

  entities.each{|entity|
    uml.add ""
    uml.add "class #{entity.name}"
    entity.attributes.each{|attribute|
      uml.add "#{entity.name} : #{attribute}"
    }
  }
  
  uml.end_uml
  uml.write(DEST_FILE)

  `java -cp #{PLANTUML_FOLDER}/plantuml.jar -jar #{PLANTUML_FOLDER}/plantuml.jar #{DEST_FILE}`
end
