require "ostruct"

module Grimoire
  class ContractObject
    def self.variables &config
      builder = Contracts::Builder.new config
      @vars = builder.variables
      @vars.each do |var|
        var.define_getter self if var.readable?
        var.define_setter self if var.writable?
      end
    end

    def self.vars; @vars; end
    def self.required_vars; @vars.select { |v| v.required? }; end

    def initialize *args
      if args.size < self.class.required_vars.size
        raise ArgumentError.new "#{self.class}#initialize expected #{self.class.required_vars.size} arguments but got #{args.size}"
      end
      self.class.vars.each.with_index do |var, i|
        var.set self, args[i]
      end
    end
  end

  ContractViolation = Class.new Exception

  module Contracts
    class Contract
      def initialize duck_methods, default
        @duck_methods = duck_methods
        @default = default
      end

      def default
        @default.call
      end

      def check object
        if object.nil?
          return default
        end

        @duck_methods.each do |name|
          if ! object.respond_to? name
            # XXX
            if object.respond_to?(:to_s) && /[0-9]{1,2}\/[0-9]{1,2}/.match(object.to_s)
              month, day = object.split("/").map { |n| n.to_i }
              return Date.new Date.today.year, month, day
              # /XXX
            else
              raise ContractViolation.new "Object #{object.inspect} does not respond to #{name.inspect}"
            end
          end
        end

        object
      end
    end

    module C
      Text = Contract.new %i[upcase start_with?], -> { "" }
      List = Contract.new %i[size push pop],      -> { [] }
      Date = Contract.new %i[day month year],     -> { ::Date.today }

      RO = OpenStruct.new :read? => true, :write? => false
      RW = OpenStruct.new :read? => true, :write? => true
      NO = OpenStruct.new :read? => false, :write? => false
    end

    class SmartVariable
      attr_reader :varname, :getter_name, :setter_name

      def initialize contract, permissions, required, name
        @contract = contract
        @permissions = permissions
        @required = required
        @name = name
        @varname = "@#{name}".to_sym
        @getter_name = name
        @setter_name = "#{name}=".to_sym
      end

      def readable?; @permissions.read?;  end
      def writable?; @permissions.write?; end
      def required?; @required;           end

      def default
        @contract.default
      end

      def contract
        @contract
      end

      def define_getter object
        object.instance_exec self do |var|
          define_method var.getter_name do
            instance_variable_get var.varname
          end
        end
      end

      def define_setter object
        var = self
        object.instance_eval do
          define_method var.setter_name do |value|
            var.set self, value
          end
        end
      end

      def set object, value
        value = @contract.check value

        var = self
        object.instance_eval do
          instance_variable_set var.varname, value
        end
      end

    end

    class Builder < BasicObject
      def initialize config
        @variables = []
        instance_eval &config
      end

      def variables
        @variables
      end

      def Text args
        @variables << SmartVariable.new(C::Text, *args)
      end

      def Date args
        @variables << SmartVariable.new(C::Date, *args)
      end

      def List args
        @variables << SmartVariable.new(C::List, *args)
      end

      def RO args
        [C::RO].concat args
      end

      def RW args
        [C::RW].concat args
      end

      def NO args
        [C::NO].concat args
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
