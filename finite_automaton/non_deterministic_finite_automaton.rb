# The difference btwn NonDeterministicFiniteAutomaton and DeterministicFiniteAutomaton is that 
# it has a set of possible current_states instead of a single definite current_state,
# State-set implementation: 
#   Maintain a state set or a state vector, keeping track of all the states 
#   that the nfa could be in at any given point in the string.
module FiniteAutomaton
  class NonDeterministicFiniteAutomaton
    attr_accessor :rulebook,
                  :accept_states,
                  :current_states
                                 
    def initialize(
      current_states, 
      accept_states, 
      rulebook, 
      non_deterministic_strategy = ::FiniteAutomaton::NonDeterministicFiniteAutomaton::Strategies::RecursiveBacktrackingStrategy.new
    )
      @rulebook = rulebook
      @accept_states = accept_states
      @current_states = rulebook.follow_free_moves(current_states)
      @non_deterministic_strategy = non_deterministic_strategy
    end

    def accepting?
      (accept_states & current_states).any?
    end

    # Use the Strategy pattern when you want to use different variants 
    # of an algorithm within an object and be able to switch from one 
    # algorithm to another during runtime. Strategies under consideration
    # are StateSetStrategy and RecursiveBacktrackingStrategy
    def read_string(string)
      @current_states = @non_deterministic_strategy.read_string(current_states, rulebook, string)
    end
  end
end