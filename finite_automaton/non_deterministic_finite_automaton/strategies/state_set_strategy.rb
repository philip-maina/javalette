module FiniteAutomaton
  class NonDeterministicFiniteAutomaton
    module Strategies
      class StateSetStrategy < BaseStrategy      
        def read_string(current_states, rulebook, string)
          @current_states = current_states
          @rulebook = rulebook
          string.chars.each { |character| read_character(character) }
          @current_states
        end
  
        private
          def read_character(character)
            @current_states = rulebook.follow_free_moves(rulebook.next_states(current_states, character))
          end
      end
    end
  end
end
