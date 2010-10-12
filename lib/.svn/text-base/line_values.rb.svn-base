
class LineValues

  # Constants that define where the Interface data is located
  INTERFACE_INDEX   = 0
  METHOD_INDEX      = 1
  PARAMETER_INDEX   = 3
  OUTPUT_INDEX      = 5

  # Constants that define where the Entity data is located
  ENTITY_INDEX      = 1
  ATTRIBUTE_INDEX   = 3

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

  def entity
    get_value(ENTITY_INDEX)
  end

  def attribute
    get_value(ATTRIBUTE_INDEX)
  end

end
