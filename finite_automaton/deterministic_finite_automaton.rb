module FiniteAutomaton
  class DeterministicFiniteAutomaton
    attr_accessor :current_state,
                  :accept_states,
                  :rulebook
                  
    def initialize(current_state, accept_states, rulebook)
      @current_state = current_state
      @accept_states = accept_states
      @rulebook = rulebook
    end

    def accepting?
      accept_states.include?(current_state)
    end

    # self used for disambiguation when assigning a value to object's attributes.
    def read_character(character)
      self.current_state = rulebook.next_state(current_state, character)
    end

    # chars returns an array of characters in string
    def read_string(string)
      string.chars.each { |character| read_character(character) }
    end
  end
end