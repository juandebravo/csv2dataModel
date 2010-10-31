module Csv2dataModel
  module Objects

    class LineValues

      # Constants that define where the Interface data is located
      INTERFACE_INDEX   = 0
      METHOD_INDEX      = 1
      PARAMETER_INDEX   = 3
      OUTPUT_INDEX      = 8
      METHOD_DEFINITION = 10

      # Constants that define where the Entity data is located
      ENTITY_INDEX      = 1
      ATTRIBUTE_INDEX   = 3

      # Constants that define where the REST Interface data is located
      REST_INTERFACE_INDEX  = 0
      REST_METHOD_INDEX     = 0
      REST_HTTP_VERB_INDEX  = 1
      REST_URI_INDEX        = 2
      REST_PARAMETERS_INDEX = 3
      REST_OUTPUT_INDEX     = 4

      # Constructor that gets as parameter an array
      def initialize (*args)
        @values = *args
      end

      # Return a strip value or nil
      def get_value(index)
        unless @values[index].nil?
          return @values[index].strip
        else
          return nil
        end
      end

      # Interface methods

      def interface
        get_value(INTERFACE_INDEX)
      end

      def method
        get_value(METHOD_INDEX)
      end

      def parameter
        get_value(PARAMETER_INDEX)
      end

      def output
        get_value(OUTPUT_INDEX)
      end

      def description
        get_value(METHOD_DEFINITION)
      end

      # Entity methods

      def entity
        get_value(ENTITY_INDEX)
      end

      def attribute
        get_value(ATTRIBUTE_INDEX)
      end

      # REST methods

      def rest_interface
        get_value(REST_INTERFACE_INDEX)
      end

      def rest_method
        get_value(REST_METHOD_INDEX)
      end

      def rest_http_verb
        get_value(REST_HTTP_VERB_INDEX)
      end

      def rest_uri
        get_value(REST_URI_INDEX)
      end

      def rest_parameters
        get_value(REST_PARAMETERS_INDEX)
      end

      def rest_output
        get_value(REST_OUTPUT_INDEX)
      end

    end
  end
end