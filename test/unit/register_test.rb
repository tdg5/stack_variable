require "test_helper"
require "stack_variable/register"

class StackVariable::RegisterTest < StackVariable::TestCase
  Subject = StackVariable::Register

  class TestSubclass < Subject
  end

  module PerThreadRegisterTests
    def self.included(base)
      base.instance_eval do
        context "scope of register" do
          should "have a unique register per Thread" do
            main_register = subject.register
            thread_register = nil
            Thread.new { thread_register = subject.register }.join
            refute_nil thread_register
            refute_equal main_register.object_id, thread_register.object_id
          end

          should "have a unique register per Fiber" do
            main_register = subject.register
            fiber_register = nil
            Fiber.new { fiber_register = subject.register }.resume
            refute_nil fiber_register
            refute_equal main_register.object_id, fiber_register.object_id
          end
        end
      end
    end
  end

  context Subject.name do

    subject { Subject }

    context "::thread_variable_key" do
      should "return the expected value" do
        expected_key = "#{Subject.name}::STACK_VARIABLES"
        assert_equal expected_key, subject.send(:thread_variable_key)
      end
    end

    context "::register" do
      include PerThreadRegisterTests
    end
  end

  context "subclass of #{Subject.name}" do
    subject { TestSubclass }

    context "::thread_variable_key" do
      should "return the expected distinct value" do
        expected_key = "#{subject.name}::STACK_VARIABLES"
        assert_equal expected_key, subject.send(:thread_variable_key)
      end
    end

    context "::register" do
      include PerThreadRegisterTests

      should "have a distinct register from parent class" do
        primary_object_id = Subject.register.object_id
        refute_equal primary_object_id, subject.register.object_id
      end
    end
  end
end

# x = stack_variable_get(:foo)
#
# stack_variable_set(:foo, :priority => 1) do
#   puts stack_variable_get(:foo)
#   stack_variable_set(:foo, :priority => 2) do
#     puts stack_variable_get(:foo)
#   end
# end
