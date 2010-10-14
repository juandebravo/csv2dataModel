$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'csv2data_model'
require 'yaml_reader'

if __FILE__ == $0
  include Csv2dataModel::Handlers

  yaml = YamlReader.new("configuration.yaml", "entities", "general")

  plantuml_folder = yaml.get_value("plantuml_folder")
  origin_file     = yaml.get_value("origin_file")
  dest_file       = yaml.get_value("dest_file")
  dest_file_wiki  = yaml.get_value("dest_file_wiki")
  image_file      = yaml.get_value("image_file")
  header_lines    = yaml.get_value("header_lines")

  # 1. load data
  csv_handler = CsvHandler.new(origin_file, ";", header_lines)
  data = csv_handler.read_file

  # 2.- convert CSV data into valid objects
  entities = csv_handler.get_entities(data)

  # 3.- generate file with valid plantUML and MediaWiki format
  uml = PlantumlHandler.new
  media = MediawikiHandler.new(dest_file_wiki)

  uml.start_uml(image_file)

  entities.each{|entity|
    uml.add ""
    uml.add_class(entity.name)
    media.add_entity(entity.name, entity.attributes)
    entity.attributes.each{|attribute|
      uml.add_attribute(attribute)
    }
  }
  uml.end_uml
  uml.write(dest_file)
  uml.generate_image(plantuml_folder, dest_file)

  media.write
end
