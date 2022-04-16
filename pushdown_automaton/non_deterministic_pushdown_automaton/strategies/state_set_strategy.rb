# NonDeterministicPushdownAutomaton is a class of its own as seen in 
# pushdown_automaton/non_determistic_pushdown_automaton.rb . But it's also
# a good namespace for its dependent entities. We can't say module NonDeterministicPushdownAutomaton 
# because that constant is already defined as a class, but we can still use it as a namespace.
module PushdownAutomaton 
  class NonDeterministicPushdownAutomaton 
    module Strategies
      class StateSetStrategy < BaseStrategy
        def read_string(current_configurations, rulebook, string)
          @current_configurations = current_configurations
          @rulebook = rulebook
          string.chars.each { |character| read_character(character) }
          @current_configurations
        end

        private
          def read_character(character)
            @current_configurations = rulebook.follow_free_moves(rulebook.next_configurations(current_configurations, character)) 
          end
      end
    end
  end
end
