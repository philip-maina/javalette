# Once a PushdownAutomaton::DeterministicPushdownAutomaton object has been fed some input, 
# it’s probably not in its start configuration anymore, so we can’t reliably reuse it to 
# check a completely new sequence of inputs. 
# 
# That means we have to recreate it from scratch—using the same start configuration, accept states, 
# and rule- book as before—every time we want to see whether it will accept a new string. 
# 
# We can avoid doing this manually by wrapping up its constructor’s arguments in an object 
# that represents the design of a particular DPDA and relying on that object to automatically 
# build one-off instances of that DPDA whenever we want to check for acceptance of a string
module PushdownAutomaton
  class DeterministicPushdownAutomaton
    class Design < Struct.new(:start_state, :accept_states, :rulebook, :stack_start_symbol)
      # tap method evaluates a block and then returns the object it was called on.
      def accepts?(string)
        to_dpda.tap { |dpda| dpda.read_string(string) }.accepting?
      end

      def to_dpda
        start_stack = Stack.new([ stack_start_symbol ])
        start_configuration = ::PushdownAutomaton::Configuration.new(start_state, start_stack, []) 
        ::PushdownAutomaton::DeterministicPushdownAutomaton.new(start_configuration, accept_states, rulebook)
      end
    end
  end
end