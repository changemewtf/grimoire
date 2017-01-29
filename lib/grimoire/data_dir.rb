require "yaml"

require "grimoire/data_object"

module Grimoire
  module DataDir
    def self.call name, &block
      name = name || "data"
      Dir["#{name}/*.yaml"].each do |file|
        data = YAML.load_file file
        create = -> d { d.respond_to?(:keys) ? DataObject.new(d) : d }
        data = if data.is_a? Array
          data.map &create
        else
          create.call data
        end
        key = File.basename(file, ".yaml").to_sym
        block.call(key) { data }
      end
    end
  end
end

class Object
  def self.data_dir name=nil
    Grimoire::DataDir.call name do |key, &func|
      define_method key, &func
    end
  end
end
