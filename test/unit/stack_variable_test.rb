require "test_helper"

class StackVariableTest < StackVariable::TestCase
  Subject = StackVariable

  subject { Subject }

  context Subject.name do
    should "be defined" do
      assert defined?(subject), "Expected #{subject.name} to be defined!"
    end
  end
end
