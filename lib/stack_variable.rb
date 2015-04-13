require "stack_variable/version"

# The namespace for the StackVariable gem.
module StackVariable
  class << self
    extend Forwardable

    def_delegators :register, :[], :[]=
  end

  def self.register
    @register ||= Register.new
  end
end
