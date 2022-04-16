# NonDeterministicFiniteAutomaton is a class of its own as seen in 
# finite_automaton/non_determistic_finite_automaton.rb . But it's also
# a good namespace for its dependent entities. We can't say module NonDeterministicFiniteAutomaton 
# because that constant is already defined as a class, but we can still use it as a namespace.
module FiniteAutomaton
  class NonDeterministicFiniteAutomaton 
    module Strategies
      class BaseStrategy
        attr_accessor :rulebook,
                      :current_states

        def read_string(current_states, rulebook, string)
          raise 'Must implement read_string!'
        end
      end
    end
  end
end
