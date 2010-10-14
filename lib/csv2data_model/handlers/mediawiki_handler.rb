
module Csv2dataModel
  module Handlers
    #
    # Class that handles the definition and creation of information related
    # to UML diagrams in MediaWiki format.
    # Writes the information in a file
    # Supported entities:
    #   - interface and its methods associated
    #   - entities and its attributes associated
    #
    class MediawikiHandler

      # File where write the information to
      attr_accessor :file

      # CSS style for any cell
      attr_accessor :cell_style

      attr_accessor :link_to_entity

      CELL_STYLE = %W(style="border:1px solid #e1eaee;background:#fffffF;").join(" ")

      CELL_CLASS_NAME_STYLE = %W(style="border:1px solid #e1eaee; background:#ABE").join(" ")

      def initialize(file = nil)
        @lines      = []
        @file       = file.nil? ? "wiki_file.txt" : file
        @cell_style = CELL_STYLE
        @link_to_entity = true
      end

      # Generic method to insert a new line in the media wiki definition
      def add(text)
        @lines ||= []
        @lines.push text
      end

      #
      # Inserts a new interface name
      #
      def add_interface(interface)
        @lines ||= []
        @lines.push "! colspan='5' style='background:#ABE' | #{interface}"
        @lines.push "|-"
      end

      #
      # Inserts a new method: name, uri, HTTP verb, parameters and output
      # Each parameter is linked to the entity wiki page if desired
      #
      def add_method(name, uri, verb, parameters, output)
        @lines ||= []
        _add_cell(name)
        _add_cell(uri)
        _add_cell(verb)
        _add_cell(_format_value(parameters))
        _add_cell(_format_value(output))
        @lines.push "|-"
      end

      #
      # Creates a new entity
      #
      def add_entity(name, attributes)
        @lines ||=[]
        #@lines.push "==[[\##{name}]]=="
        @lines.push "==[[#{name.downcase}]]=="
        @lines.push "{|border=\"0\" cellpadding=\"2\" width=\"40%\""
        _add_cell(name, CELL_CLASS_NAME_STYLE)
        @lines.push "|-"
        attributes.each{|attribute|
          _add_cell(attribute)
          @lines.push "|-"
        }
        @lines.push "|}"
        @lines.push "<br/>"
      end

      def start_page
        @lines ||= []
        @lines.push "{|border=\"0\" cellpadding=\"2\" width=\"95%\""
        @lines.push "|#{CELL_STYLE} width=20%| Method"
        @lines.push "|#{CELL_STYLE} width=30%| URI"
        @lines.push "|#{CELL_STYLE} width=15%| HTTP Verb"
        @lines.push "|#{CELL_STYLE} width=20%| Parameters"
        @lines.push "|#{CELL_STYLE} width=15%| Output"
        @lines.push "|-"
      end

      def end_page

      end

      #
      # Write lines to file, either the parameter or the object instance defined
      #
      def write(file=nil)
        file = file.nil? ? @file : file
        File.open(file, 'w+') {|f|
          @lines.each{|line|
            f.write("#{line}\r\n")
          }
        }
      end

      private

      def _format_value(value)
        if value.nil? or value.empty?
          return value
        end
        value = value.gsub(/[\n]/,'<br/>')
        @link_to_entity and value = value.gsub(/\([a-zA-Z]*\)/) {|s| "([[Entities#e#{s[1..-2].downcase}]])"}
        value
      end

      def _add_cell(text = "", cell_style = @cell_style)
        @lines.push "|#{cell_style}| #{text}"
      end
    end
  end
end
