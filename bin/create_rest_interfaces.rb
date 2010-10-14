$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'csv2data_model'
require 'yaml_reader'

if __FILE__ == $0
  include Csv2dataModel::Handlers

  yaml = YamlReader.new("configuration.yaml", "rest_interfaces", "general")

  origin_file     = yaml.get_value("origin_file")
  dest_file       = yaml.get_value("dest_file")
  header_lines    = yaml.get_value("header_lines")

  # 1. load data
  csv_handler = CsvHandler.new(origin_file, ";", header_lines)
  data = csv_handler.read_csv

  # 2.- convert CSV data into valid objects
  interfaces = csv_handler.get_rest_interfaces(data)

  # 3.- generate file with valid MediaWiki format
  media = MediawikiHandler.new(dest_file)
  media.start_page

  interfaces.each{|interface|
    media.add_interface(interface.name)
    interface.methods.each{|method|
      media.add_method(method.name, method.uri, method.verb, method.parameters.nil? ? "" : method.parameters, method.output)
    }
  }
  media.end_page
  media.write
  
end
