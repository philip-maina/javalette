require 'set'

module PushdownAutomaton
  class NonDeterministicPushdownAutomaton
    class RuleBook < Struct.new(:rules)

      # flat_map is the same as map {}.flatten!.
      def next_configurations(configurations, character)
         configurations.flat_map { |configuration| follow_rules_for(configuration, character) }.to_set
      end

      def follow_rules_for(configuration, character)
        rules_for(configuration, character).map { |rule| rule.follow(configuration) }
      end

      def rules_for(configuration, character)
        rules.select { |rule| rule.applies_to?(configuration, character) }
      end

      def follow_free_moves(configurations)
        more_configurations = next_configurations(configurations, nil)
        more_configurations.subset?(configurations) ? configurations : follow_free_moves(configurations + more_configurations)
      end
    end
  end
end