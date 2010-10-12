# To change this template, choose Tools | Templates
# and open the template in the editor.

class PlantumlHandler
  
  attr_accessor :file_name

  def initialize
    @uml = []
    @file_name = "uml_file.png"
  end

  def add(text)
    @uml ||= []
    @uml.push text
  end

  def start_uml(file_name = nil)
    _file_name = file_name.nil? ? @file_name : file_name
    add("@startuml img/#{_file_name}")
  end

  def end_uml
    add("@enduml")
  end

  def write(file)
    File.open(file, 'w+') {|f|
      @uml.each{|line|
        f.write("#{line}\r\n")
      }
    }
  end

end
