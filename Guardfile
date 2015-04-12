guard(:minitest, :all_after_pass => false, :all_on_start => false) do
  watch(%r{^lib/stack_variable/(.+)\.rb$}) { |m| "test/unit/#{m[1]}_test.rb" }
  watch(%r{^test/.+_test\.rb$})
  watch(%r{^(?:test/test_helper(.*)|lib/stack_variable)\.rb$}) { "test" }
end
