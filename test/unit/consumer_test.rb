require "test_helper"
require "stack_variable/consumer"

class StackVariable::ConsumerTest < StackVariable::TestCase
  Subject = StackVariable::Consumer

  class TestSubject
    include Subject
    alias_method :public_stack_variable_get, :stack_variable_get
    alias_method :public_stack_variable_set, :stack_variable_set
  end

  context "instance" do
    subject { TestSubject.new }

    context "#stack_variable_get" do
      should "return nil if no such variable exists" do
        assert_nil subject.public_stack_variable_get(:no_such_value)
      end
    end

    context "#stack_variable_set" do
      should "raise an ArgumentError if called without block" do
        assert_raises(ArgumentError) do
          subject.stack_variable_set(:foo, "candy bars")
        end
      end
    end

    context "#register" do
      should "return a consistent unique Register per Thread" do
      end

      should "return a consistent unique Register per Fiber" do
      end
    end
  end
end
