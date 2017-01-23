module Grimoire
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
end
