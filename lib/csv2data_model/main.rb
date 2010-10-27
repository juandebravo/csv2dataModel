
require 'csv2data_model/yaml_reader'

module Csv2dataModel

  class Main

    # Shortcut to handlers
    include Csv2dataModel::Handlers

    DEFAULT_NAMESPACE = "general"

    def initialize

    end

    #
    # Creates the outpus associated with interfaces
    #
    # [input_file] file to load with interfaces definition
    # [header_lines] number of lines to skip
    # [generate_uml] true|false
    # [plantuml_folder] location of plantuml program
    #
    #
    def self.create_interfaces(input_file = nil, header_lines = nil, generate_uml = true, plantuml_folder = nil)
      Main.load_yaml(DEFAULT_NAMESPACE, "interfaces")

      input_file.nil?      and input_file      = @@yaml.get_value("input_file", namespace)
      header_lines.nil?    and header_lines    = @@yaml.get_value("header_lines", namespace)
      generate_uml.nil?    and generate_uml    = @@yaml.get_value("generate_uml", namespace)
      plantuml_folder.nil? and plantuml_folder = @@yaml.get_value("plantuml_folder")

      output_file     = @@yaml.get_value("output_file")
      image_file      = @@yaml.get_value("image_file")

      csv_handler = CsvHandler.new(input_file, ";", header_lines)

      # 1. load data
      data = csv_handler.read_file

      # 2.- convert CSV data into valid objects
      interfaces = csv_handler.get_interfaces(data)

      # 3.- generate file with valid plantUML format
      uml = PlantumlHandler.new(image_file)
      uml.start_uml

      interfaces.each{|interface|
        uml.add ""
        uml.add_interface(interface.name)
        interface.methods.each{|method|
          uml.add_method(method.name, method.parameters, method.output)
        }
      }

      uml.end_uml
      uml.write(output_file)
      uml.generate_image(plantuml_folder, output_file)
    end


    #
    # Creates the outpus associated with entities
    #
    # [input_file] file to load with entitites definition
    # [header_lines] number of lines to skip
    # [generate_uml] true|false
    # [generate_wiki] true|false
    # [plantuml_folder] location of plantuml program
    #
    def self.create_entities(input_file = nil, header_lines = nil, generate_uml = true, generate_wiki = true, plantuml_folder = nil)
      Main.load_yaml(DEFAULT_NAMESPACE, "entities")

      input_file.nil?      and input_file      = @@yaml.get_value("input_file")
      header_lines.nil?    and header_lines    = @@yaml.get_value("header_lines")
      generate_uml.nil?    and generate_uml    = @@yaml.get_value("generate_uml")
      generate_wiki.nil?   and generate_wiki   = @@yaml.get_value("generate_wiki")
      plantuml_folder.nil? and plantuml_folder = @@yaml.get_value("plantuml_folder")

      output_file     = @@yaml.get_value("output_file")
      output_file_wiki= @@yaml.get_value("output_file_wiki")
      image_file      = @@yaml.get_value("image_file")

      # 1. load data
      csv_handler = CsvHandler.new(input_file, ";", header_lines)
      data = csv_handler.read_file

      # 2.- convert CSV data into valid objects
      # get_entities returns an array of Entity objects
      entities = csv_handler.get_entities(data)

      # 3.- generate file with valid plantUML
      if generate_uml
        uml = PlantumlHandler.new(image_file)
        # Initial line
        uml.start_uml
        # For each entity, insert entity definition
        entities.each{|entity|
          uml.add ""
          uml.add_class(entity.name)
          # For each attribute, insert attribute definition
          entity.attributes.each{|attribute|
            uml.add_attribute(attribute)
          }
        }
        # End line
        uml.end_uml
        # Write content to file
        uml.write(output_file)
        uml.generate_image(plantuml_folder, output_file)
      end

      # 4.- generate file with valid MediaWiki format
      if generate_wiki
        media = MediawikiHandler.new(output_file_wiki)
        # For each entity, insert entity definition
        entities.each{|entity|
          media.add_entity(entity.name, entity.attributes)
        }
        media.write
      end
    end

    #
    # Creates the outputs associated with rest interfaces
    #
    # [input_file] file to load with REST interface definition
    # [header_lines] number of lines to skip
    #
    def self.create_rest(input_file = nil, header_lines = nil)
      Main.load_yaml(DEFAULT_NAMESPACE, "rest_interfaces")

      input_file.nil?  and input_file  = @@yaml.get_value("input_file", namespace)
      header_lines.nil? and header_lines = @@yaml.get_value("header_lines", namespace)

      output_file = @@yaml.get_value("output_file")

      # 1. load data
      csv_handler = CsvHandler.new(input_file, ";", header_lines)
      data = csv_handler.read_csv

      # 2.- convert CSV data into valid objects
      interfaces = csv_handler.get_rest_interfaces(data)

      # 3.- generate file with valid MediaWiki format
      media = MediawikiHandler.new(output_file)
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

    def self.load_yaml(default_namespace=nil, namespace=nil)
      # Read the configuration file
      @@yaml = YamlReader.new("configuration.yaml")
      unless default_namespace.nil?
        @@yaml.default_namespace = default_namespace
      end
      unless namespace.nil?
        @@yaml.namespace = namespace
      end
    end
  end
end
