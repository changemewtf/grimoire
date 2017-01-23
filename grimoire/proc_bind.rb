class Proc
  def bind object
    object.instance_exec self, Time.now do |block, time|
      class << self
        method_name = "__bind_#{time.to_i}_#{time.usec}"
        define_method method_name, &block
        method = instance_method method_name
        remove_method method_name
        method
      end
    end.bind object
  end
end
