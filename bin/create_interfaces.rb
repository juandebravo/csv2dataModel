$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'csv2data_model'
require 'yaml_reader'

if __FILE__ == $0
  include Csv2dataModel::Handlers

  yaml = YamlReader.new("configuration.yaml", "interfaces", "general")

  plantuml_folder = yaml.get_value("plantuml_folder")
  origin_file     = yaml.get_value("origin_file")
  dest_file       = yaml.get_value("dest_file")
  image_file      = yaml.get_value("image_file")
  header_lines    = yaml.get_value("header_lines")

  csv_handler = CsvHandler.new(origin_file, ";", header_lines)

  # 1. load data
  data = csv_handler.read_file

  # 2.- convert CSV data into valid objects
  interfaces = csv_handler.get_interfaces(data)

  # 3.- generate file with valid plantUML format
  uml = PlantumlHandler.new
  uml.start_uml(image_file)

  interfaces.each{|interface|
    uml.add ""
    uml.add_interface(interface.name)
    interface.methods.each{|method|
      uml.add_method(method.name, method.parameters, method.output)
    }
  }

  uml.end_uml
  uml.write(dest_file)
  uml.generate_image(plantuml_folder, dest_file)
end
