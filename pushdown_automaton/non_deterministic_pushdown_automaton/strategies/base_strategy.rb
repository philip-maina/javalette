# NonDeterministicPushdownAutomaton is a class of its own as seen in 
# pushdown_automaton/non_determistic_pushdown_automaton.rb . But it's also
# a good namespace for its dependent entities. We can't say module NonDeterministicPushdownAutomaton 
# because that constant is already defined as a class, but we can still use it as a namespace.
module PushdownAutomaton 
  class NonDeterministicPushdownAutomaton 
    module Strategies
      class BaseStrategy
        attr_accessor :rulebook,
                      :current_configurations

        def read_string(current_configurations, rulebook, string)
          raise 'Must implement read_string!'
        end
      end
    end
  end
end
