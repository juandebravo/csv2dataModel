
class YamlReader

  FILE = File.new(File.join(File.dirname(__FILE__), "configuration.yaml"))

  attr_accessor :default_namespace

  attr_accessor :namespace

  def initialize(file = nil, namespace = nil, default_namespace = nil)
    @default_namespace = default_namespace.nil? ? "general" : default_namespace
    @namespace = namespace.nil? ? @default_namespace : namespace
    unless file.nil?
      self.load_yaml(file)
    end
  end

  def load_yaml(file = nil)
    # YAML::load(File.new(File.join(File.dirname(__FILE__), file)))
    @yaml_values = YAML::load(File.new(file))
  end

  def get_value(key)
    unless @namespace.nil? or @namespace.eql?(@default_namespace)
      value = @yaml_values[@namespace][key]
      if value.nil?
        value = @yaml_values[@default_namespace][key]
      end
    else
      value = @yaml_values[@default_namespace][key]
    end
    value
  end
    
end
