# A DFA rulebook always returns a single state when we ask it 
# where the DFA should go next after reading a particular character while in a specific state, 
# but an NFA rulebook needs to answer a different question: when an NFA is possibly in one of 
# several states, and it reads a particular character, what states can it possibly be in next? 
# 
# We're using Set class instead of Array to store ccollection of states because:
#   a) It automatically eliminates duplicate elements.
#   b) It ignores the order of elements.
require 'set'

module FiniteAutomaton
  class NonDeterministicFiniteAutomaton
    class RuleBook < Struct.new(:rules)
      # flat_map is the same as map {}.flatten!.
      def next_states(states, character)
        states.flat_map { |state| follow_rules_for(state, character) }.to_set
      end

      def follow_rules_for(state, character) 
        rules_for(state, character).map(&:follow)
      end

      def rules_for(state, character)
        rules.select { |rule| rule.applies_to?(state, character) }
      end

      # Find all states that can be reached from given states 
      # on one or more epsilon transitions. (Epsilon closure)
      # nil represents epsilon.
      def follow_free_moves(states)
        more_states = next_states(states, nil)
        more_states.subset?(states) ? states : follow_free_moves(states + more_states) 
      end

      # Remove nils which represent epsilon transitions.
      def alphabet
        rules.map(&:character).compact.uniq
      end
    end
  end
end