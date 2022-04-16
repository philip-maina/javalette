# Inherit from Struct, gets rid of the initialize method and our 
# class will pretty much behave like it should, and another convenience of 
# this is that the Struct will provide us with accessor methods
module FiniteAutomaton
  class Rule < Struct.new(:state, :character, :next_state)

    # Indicates whether that rule applies in a particular situation
    def applies_to?(state, character)
      (self.state == state) && (self.character == character)
    end

    # Returns information about how the machine should change when a rule is followed
    def follow
      next_state
    end

    # Custom string representations of the object/class instances
    def inspect
      "#<FiniteAutomaton::Rule #{state.inspect} ---#{character}---> #{next_state.inspect}>"
    end
  end
end