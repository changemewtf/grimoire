require "ostruct"

require "grimoire/contracts"

class ::Object
  private

  def self.smart_variables &block
    Grimoire::SmartVariables.call self, &block
    nil
  end
end

module Grimoire
  module SmartVariables
    def self.call klass, &config
      klass.extend ClassMethods
      builder = Grimoire::SmartVariables::Builder.new config
      klass.configure_smart_variables builder.variables
    end

    module ClassMethods
      def configure_smart_variables vars
        required_variables = vars.select { |v| v.required? }

        vars.each do |var|
          define_method var.getter do
            instance_variable_get var.name
          end if var.readable?

          define_method var.setter do |value|
            instance_variable_set var.name, var.check(value)
          end if var.writable?

          define_method :initialize do |*args|
            if args.size < required_variables.size
              raise ArgumentError.new "#{self.class}#initialize expected #{required_variables.size} arguments but got #{args.size}"
            end
            vars.each.with_index do |var, i|
              instance_variable_set var.name, var.check(args[i])
            end
          end
        end
      end
    end

    module Permissions
      RO = OpenStruct.new :read? => true, :write? => false
      RW = OpenStruct.new :read? => true, :write? => true
      NO = OpenStruct.new :read? => false, :write? => false
    end

    class SmartVariable
      def initialize contract, permissions, required, name
        @contract = contract
        @permissions = permissions
        @required = required
        @name = name
      end

      def getter;      @name;               end
      def setter;      "#{@name}=".to_sym;  end
      def name;        "@#{@name}".to_sym;  end
      def readable?;   @permissions.read?;  end
      def writable?;   @permissions.write?; end
      def required?;   @required;           end

      def check value
        @contract.check value
      end
    end

    class Builder < BasicObject
      attr_reader :variables

      def initialize config
        @variables = []
        instance_eval &config
      end

      ::Grimoire::Contracts.constants.each do |contract|
        define_method contract do |args|
          @variables << SmartVariable.new(
            ::Grimoire::Contracts.const_get(contract), *args
          )
        end
      end

      ::Grimoire::SmartVariables::Permissions.constants.each do |permission|
        define_method permission do |args|
          [::Grimoire::SmartVariables::Permissions.const_get(permission)].concat args
        end
      end

      def Required args
        [true].concat args
      end

      def Optional args
        [false].concat args
      end

      def method_missing name, *args
        [name]
      end
    end
  end
end
