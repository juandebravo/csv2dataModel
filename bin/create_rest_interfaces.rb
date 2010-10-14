$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'csv2data_model'

if __FILE__ == $0
  include Csv2dataModel::Handlers

  ORIGIN_FILE     = "input/RestInterfaces.csv"
  DEST_FILE       = "output/rest_interfaces_wiki.txt"

  HEADER_LINES    = 2

  csv_handler = CsvHandler.new(ORIGIN_FILE, ";", HEADER_LINES)

  # 1. load data
  data = csv_handler.read_csv

  # 2.- convert CSV data into valid objects
  interfaces = csv_handler.get_rest_interfaces(data)

  # 3.- generate file with valid plantUML format
  media = MediawikiHandler.new(DEST_FILE)
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
