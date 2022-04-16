# Once a FiniteAutomaton::DeterministicFiniteAutomaton object has been fed some input, 
# it’s probably not in its start state anymore, so we can’t reliably reuse it to 
# check a completely new sequence of inputs. 
# 
# That means we have to recreate it from scratch—using the same start state, accept states, 
# and rule- book as before—every time we want to see whether it will accept a new string. 
# 
# We can avoid doing this manually by wrapping up its constructor’s arguments in an object 
# that represents the design of a particular DFA and relying on that object to automatically 
# build one-off instances of that DFA whenever we want to check for acceptance of a string
module FiniteAutomaton
  class DeterministicFiniteAutomaton
    class Design < Struct.new(:start_state, :accept_states, :rulebook)
      # tap method evaluates a block and then returns the object it was called on.
      def accepts?(string)
        to_dfa.tap { |dfa| dfa.read_string(string) }.accepting?
      end
      
      def to_dfa
        DeterministicFiniteAutomaton.new(start_state, accept_states, rulebook) 
      end
    end
  end
end