require './javalette'
require "minitest/autorun"
module FiniteAutomaton
  class NonDeterministicFiniteAutomaton::DesignTest < Minitest::Test

    def rules_for_strings_ending_with_zero
      [
        FiniteAutomaton::Rule.new(0, '0', 0),
        FiniteAutomaton::Rule.new(0, '1', 0),
        FiniteAutomaton::Rule.new(0, '0', 1),
        FiniteAutomaton::Rule.new(1, '1', 2)
      ]
    end

    def rules_for_strings_where_third_character_from_right_is_zero
      [
        FiniteAutomaton::Rule.new(0, '0', 0),
        FiniteAutomaton::Rule.new(0, '1', 0),
        FiniteAutomaton::Rule.new(0, '0', 1),
        FiniteAutomaton::Rule.new(1, '0', 2),
        FiniteAutomaton::Rule.new(1, '1', 2),
        FiniteAutomaton::Rule.new(2, '0', 3),
        FiniteAutomaton::Rule.new(2, '1', 3)
      ]
    end

    def rules_for_strings_with_specified_substrings
      [
        FiniteAutomaton::Rule.new(0, '0', 0),
        FiniteAutomaton::Rule.new(0, '1', 0),
        FiniteAutomaton::Rule.new(0, '1', 1),
        FiniteAutomaton::Rule.new(1, '1', 2),
        FiniteAutomaton::Rule.new(2, '1', 3),
        FiniteAutomaton::Rule.new(3, '0', 4),
        FiniteAutomaton::Rule.new(4, '0', 4),
        FiniteAutomaton::Rule.new(4, '1', 4)
      ]
    end
    
    # Design an NFA with ∑ = {0, 1} that accepts all strings ending with 01.
    def test_can_recognize_strings_ending_with_zero_one
      start_state = 0
      accept_states = [2]
      rulebook = FiniteAutomaton::NonDeterministicFiniteAutomaton::RuleBook.new(rules_for_strings_ending_with_zero)
      nfa_design = 
        FiniteAutomaton::NonDeterministicFiniteAutomaton::Design.new(
          start_state,
          accept_states,
          rulebook
        )
      
      assert nfa_design.accepts?('1010101')
      assert nfa_design.accepts?('01')
      refute nfa_design.accepts?('1')
      refute nfa_design.accepts?('001011')
    end

    # Design an NFA with ∑ = {0, 1} that accepts all strings in which the third symbol 
    # from the right is always 0.
    def test_can_recognize_strings_where_third_character_from_right_is_zero
      start_state = 0
      accept_states = [3]
      rulebook = FiniteAutomaton::NonDeterministicFiniteAutomaton::RuleBook.new(rules_for_strings_where_third_character_from_right_is_zero)
      nfa_design = 
        FiniteAutomaton::NonDeterministicFiniteAutomaton::Design.new(
          start_state,
          accept_states,
          rulebook
        )
      
      assert nfa_design.accepts?('0010001')
      assert nfa_design.accepts?('010')
      refute nfa_design.accepts?('1')
      refute nfa_design.accepts?('101101')
    end

    # Design an NFA with ∑ = {0, 1} in which all the strings contain a substring 1110.
    def test_can_recognize_strings_with_specified_substring
      start_state = 0
      accept_states = [4]
      rulebook = FiniteAutomaton::NonDeterministicFiniteAutomaton::RuleBook.new(rules_for_strings_with_specified_substrings)
      nfa_design = 
        FiniteAutomaton::NonDeterministicFiniteAutomaton::Design.new(
          start_state,
          accept_states,
          rulebook
        )
      
      assert nfa_design.accepts?('00111001')
      assert nfa_design.accepts?('1110')
      refute nfa_design.accepts?('0')
      refute nfa_design.accepts?('101101')
    end
  end
end