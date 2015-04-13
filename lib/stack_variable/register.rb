module StackVariable
  class Register
    class << self
      def register
        Thread.current[thread_variable_key] || ensure_thread_register
      end

      private

      def ensure_thread_register
        mutex.synchronize do
          current_register = Thread.current[thread_variable_key]
          return current_register if current_register

          main_register = Thread.main[thread_variable_key] ||= {}
          return main_register if Thread.current == Thread.main

          Thread.current[thread_variable_key] ||= main_register.dup
          return Thread.current[thread_variable_key]
        end
      end

      def mutex
        @mutex ||= Mutex.new
      end

      def thread_variable_key
        @thread_variable_key ||= "#{name}::STACK_VARIABLES"
      end
    end

    def register
      self.class.register
    end

    def stack_variable_get(key)
      register[key]
    end
    alias_method :[], :stack_variable_get

    def stack_variable_set(key, value)
      raise ArgumentError, "Block required!" unless block_given?
      old_value = stack_variable_get(key)
      register[key] = value
      result = yield
      register[key] = old_value
      result
    end
    alias_method :[]=, :stack_variable_set
  end
end
