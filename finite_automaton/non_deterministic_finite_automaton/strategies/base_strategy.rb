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
