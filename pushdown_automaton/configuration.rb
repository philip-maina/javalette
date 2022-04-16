# Just like a transition/rule in finite automaton defined a move
# from one state to another, in a pushdown automaton a rule defines
# a move from one configuration (combination of state and stack contents) to another
# 
# Metadata: 
#   • We can record the sequence of rules followed thus far to get to the configuration.
#     This will help provide information on building a parse tree if necessary if the
#     configuration has an accept state.

module PushdownAutomaton
  class Configuration < Struct.new(:state, :stack, :sequence_of_rules)
    DEAD_STATE = Object.new

    def dead_state?
      state == DEAD_STATE
    end

    def deep_clone
      Marshal.load(Marshal.dump(self))
    end
  end
end