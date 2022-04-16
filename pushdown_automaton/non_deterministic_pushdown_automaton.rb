module PushdownAutomaton
  class NonDeterministicPushdownAutomaton
    attr_accessor :current_configurations,
                  :accept_states,
                  :rulebook
                  
    def initialize(
      current_configurations, 
      accept_states, 
      rulebook,
      non_deterministic_strategy
    )
      @rulebook = rulebook
      @accept_states = accept_states
      @current_configurations = rulebook.follow_free_moves(current_configurations)
      @non_deterministic_strategy = non_deterministic_strategy
    end

    # This is acceptance by final state. There's also acceptance
    # by empty stack but we won't use that method.
    def accepting?
      current_configurations.any? { |configuration| accept_states.include?(configuration.state) }
    end

    def read_string(string)
      @current_configurations = @non_deterministic_strategy.read_string(current_configurations, rulebook, string)
    end
  end
end