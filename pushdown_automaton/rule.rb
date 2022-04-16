# Inherit from Struct, gets rid of the initialize method and our 
# class will pretty much behave like it should, and another convenience of 
# this is that the Struct will provide us with accessor methods
module PushdownAutomaton
  class Rule < Struct.new(:state, :character, :next_state, :pop_character, :push_characters)

    # Indicates whether that rule applies in a particular situation
    def applies_to?(configuration, character)
      (self.character == character) &&
      (self.state == configuration.state) &&
      (self.pop_character == configuration.stack.top)
    end

    # Returns information about how the machine should change when a rule is followed
    # Should change to a new configuration
    def follow(configuration)
      next_configuration = configuration.deep_clone
      next_configuration.state = next_state

      next_configuration.stack.pop
      next_configuration.stack.push(push_characters.reverse)

      next_configuration.sequence_of_rules.push(self)

      next_configuration
    end

    # Custom string representations of the object/class instances
    def inspect
      "#<PushdownAutomaton::Rule #{state.inspect} ---#{character};#{pop_character}/#{push_characters.join}---> #{next_state.inspect}>"
    end
  end
end