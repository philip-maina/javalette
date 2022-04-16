# A rulebook lets us wrap up many rules into a single object 
# and ask it questions about which state comes next
module FiniteAutomaton
  class DeterministicFiniteAutomaton
    class RuleBook < Struct.new(:rules)
      def next_state(state, character)
        rule_for(state, character).follow
      end

      # Since this is a DFA, then we can employ detect method as it 
      # assumes that there will always be exactly one rule that 
      # applies to the given state and character. i.e Returns the first for which block is not false.
      def rule_for(state, character)
        rules.detect { |rule| rule.applies_to?(state, character) }
      end
    end
  end
end