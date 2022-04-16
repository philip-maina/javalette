# A rulebook lets us wrap up many rules into a single object 
# and ask it questions about which configuration comes next i.e
# locates the correct rule and discovers what the next configuration of the DPDA should be.
# 
# If no rule is applicable for the configuration and character then go to a
# configuration where the state is DEAD/TRAP state (non-accepting state that goes to 
# itself on every possible input symbol).
module PushdownAutomaton
  class DeterministicPushdownAutomaton
    class RuleBook < Struct.new(:rules)
      def next_configuration(configuration, character)
        applicable_rule = rule_for(configuration, character)
        if applicable_rule.nil? 
          ::PushdownAutomaton::Configuration.new(
            ::PushdownAutomaton::Configuration::DEAD_STATE, 
            configuration.stack
          )
        else
          applicable_rule.follow(configuration)
        end
      end

      # Since this is a DPDA, then we can employ detect method as it 
      # assumes that there will always be exactly one rule that 
      # applies to the given configuration and character. i.e Returns the first for which block is not false.
      def rule_for(configuration, character)
        rules.detect { |rule| rule.applies_to?(configuration, character) }
      end

      # Find all states that can be reached from given states 
      # on one or more epsilon transitions. (Epsilon closure)
      # nil represents epsilon.
      # 
      # In deterministic pushdown automatons unlike deterministic finite automaton, it’s
      # okay to write a free move rule that doesn’t read any input, as long as there aren’t 
      # any other rules for the same state and top-of-stack character, because that would
      # create an ambiguity. This is especially useful when moving to the final state where the
      # transition looks like so q(i) ===== ε;Z0/Z0 =====> q(f)
      def follow_free_moves(configuration)
        rule_for(configuration, nil).nil? ?
          configuration : 
          follow_free_moves(next_configuration(configuration, nil))
      end
    end
  end
end