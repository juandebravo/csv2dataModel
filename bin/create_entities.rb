$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'csv2data_model'

if __FILE__ == $0
  include Csv2dataModel::Handlers

  PLANTUML_FOLDER = "/Users/jdbd/bin/"

  ORIGIN_FILE   = "input/Entities.csv"
  DEST_FILE     = "output/entities.txt"
  DEST_FILE_WIKI= "output/entities_wiki.txt"
  IMAGE_FILE    = "entities.png"

  HEADER_LINES    = 2

  # 1. load data
  csv_handler = CsvHandler.new(ORIGIN_FILE, ";", HEADER_LINES)
  data = csv_handler.read_file

  # 2.- convert CSV data into valid objects
  entities = csv_handler.get_entities(data)

  # 3.- generate file with valid plantUML format
  uml = PlantumlHandler.new
  media = MediawikiHandler.new(DEST_FILE_WIKI)

  uml.start_uml(IMAGE_FILE)

  entities.each{|entity|
    uml.add ""
    uml.add_class(entity.name)
    media.add_entity(entity.name, entity.attributes)
    entity.attributes.each{|attribute|
      uml.add_attribute(attribute)
    }
  }
  
  uml.end_uml
  uml.write(DEST_FILE)
  media.write

  `java -cp #{PLANTUML_FOLDER}/plantuml.jar -jar #{PLANTUML_FOLDER}/plantuml.jar #{DEST_FILE}`
end
