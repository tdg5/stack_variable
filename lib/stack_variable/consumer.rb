require "stack_variable/register"

module StackVariable::Consumer
  def stack_variable_get(key)
    StackVariable.register[key]
  end

  def stack_variable_set(key, value)
    raise ArgumentError, "Block required!" unless block_given?
    StackVariable.register[key] = value
    yield
    StackVariable.register[key] = other_value
  end
end
