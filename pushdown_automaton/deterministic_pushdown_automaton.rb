module PushdownAutomaton
  class DeterministicPushdownAutomaton
    attr_accessor :current_configuration,
                  :accept_states,
                  :rulebook
                  
    def initialize(current_configuration, accept_states, rulebook)
      @rulebook = rulebook
      @accept_states = accept_states
      @current_configuration = rulebook.follow_free_moves(current_configuration)
    end

    # This is acceptance by final state. There's also acceptance
    # by empty stack but we won't use that method.
    def accepting?
      accept_states.include?(current_configuration.state)
    end

    # self used for disambiguation when assigning a value to object's attributes.
    def read_character(character)
      @current_configuration = rulebook.follow_free_moves(rulebook.next_configuration(current_configuration, character))
    end

    # chars returns an array of characters in string
    def read_string(string)
      string.chars.each { |character| read_character(character) unless current_configuration.dead_state? }
    end
  end
end