
#
# This class is a wrapper to get values from a YAML file
#
class YamlReader

  attr_accessor :default_namespace

  attr_accessor :namespace

  def initialize(file = nil, default_namespace = nil)
    @default_namespace = default_namespace.nil? ? "general" : default_namespace
    unless file.nil?
      self.load_yaml(file)
    end
  end

  #
  # Load a YAML file and holds the information in an instance variable
  #
  def load_yaml(file = nil)
    # Example of how to read a file concatenating folders
    # YAML::load(File.new(File.join(File.dirname(__FILE__), file)))
    @yaml_values = YAML::load(File.new(file))
  end

  #
  # Retrieves a value from the specific namespace being used or from the
  # default namespace if the key is not found in the specific one
  #
  def get_value(key, namespace = nil)
    namespace = get_namespace(namespace)
    value = @yaml_values[namespace][key]
    value
  end

  private

  def get_namespace(namespace)
    namespace.nil? ? (@namespace.nil? ? @default_namespace : @namespace) : namespace
  end
    
end
