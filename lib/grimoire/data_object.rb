require "forwardable"

module Grimoire
  class DataObject
    extend Forwardable

    def initialize attributes
      @attributes = {}
      attributes.each do |key, value|
        varname = "@#{key}".to_sym
        instance_variable_set varname, value
        define_singleton_method key.to_sym do
          instance_variable_get varname
        end
        @attributes[key] = value
      end
    end

    def_delegators %i[@attributes each keys values]

    def [] name
      instance_variable_get "@#{name}".to_sym
    end
  end
end
