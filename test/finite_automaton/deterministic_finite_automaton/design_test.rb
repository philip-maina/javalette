require './javalette'
require "minitest/autorun"
module FiniteAutomaton
  class DeterministicFiniteAutomaton::DesignTest < Minitest::Test

    def rules_for_string_ending_with_one_zero_zero
      [
        FiniteAutomaton::Rule.new(0, '0', 0),
        FiniteAutomaton::Rule.new(0, '1', 1),
        FiniteAutomaton::Rule.new(1, '0', 2),
        FiniteAutomaton::Rule.new(1, '1', 1),
        FiniteAutomaton::Rule.new(2, '0', 3),
        FiniteAutomaton::Rule.new(2, '1', 1),
        FiniteAutomaton::Rule.new(3, '0', 0),
        FiniteAutomaton::Rule.new(3, '1', 1)
      ]
    end

    def rules_for_strings_where_third_character_from_left_is_zero
      [
        FiniteAutomaton::Rule.new(0, '0', 1),
        FiniteAutomaton::Rule.new(0, '1', 1),
        FiniteAutomaton::Rule.new(1, '0', 2),
        FiniteAutomaton::Rule.new(1, '1', 2),
        FiniteAutomaton::Rule.new(1, '0', 2),
        FiniteAutomaton::Rule.new(1, '1', 2),
        FiniteAutomaton::Rule.new(2, '0', 3),
        FiniteAutomaton::Rule.new(2, '1', 4),
        FiniteAutomaton::Rule.new(3, '0', 3),
        FiniteAutomaton::Rule.new(3, '1', 3),
        FiniteAutomaton::Rule.new(4, '0', 4),
        FiniteAutomaton::Rule.new(4, '1', 4)
      ]
    end

    def rules_for_strings_with_specified_substrings
      [
        FiniteAutomaton::Rule.new(0, '0', 1),
        FiniteAutomaton::Rule.new(0, '1', 0),
        FiniteAutomaton::Rule.new(1, '0', 1),
        FiniteAutomaton::Rule.new(1, '1', 2),
        FiniteAutomaton::Rule.new(2, '0', 2),
        FiniteAutomaton::Rule.new(2, '1', 2)
      ]
    end

    # Design an NFA with ∑ = {0, 1} that accepts all strings ending with 100.
    def test_can_recognize_strings_ending_with_one_zero_zero
      start_state = 0
      accept_states = [3]
      rulebook = FiniteAutomaton::DeterministicFiniteAutomaton::RuleBook.new(rules_for_string_ending_with_one_zero_zero)
      dfa_design = 
        FiniteAutomaton::DeterministicFiniteAutomaton::Design.new(
          start_state,
          accept_states,
          rulebook
        )
      
      assert dfa_design.accepts?('1010100')
      assert dfa_design.accepts?('100')
      refute dfa_design.accepts?('1')
      refute dfa_design.accepts?('001011')
    end

    # Design an NFA with ∑ = {0, 1} that accepts all strings in which the third symbol 
    # from the left is always 0.
    def test_can_recognize_strings_where_third_character_from_left_is_zero
      start_state = 0
      accept_states = [3]
      rulebook = FiniteAutomaton::DeterministicFiniteAutomaton::RuleBook.new(rules_for_strings_where_third_character_from_left_is_zero)
      dfa_design = 
        FiniteAutomaton::DeterministicFiniteAutomaton::Design.new(
          start_state,
          accept_states,
          rulebook
        )
      
      assert dfa_design.accepts?('1000001')
      assert dfa_design.accepts?('010')
      refute dfa_design.accepts?('1')
      refute dfa_design.accepts?('101101')
    end

    # Design an NFA with ∑ = {0, 1} in which all the strings contain a substring 01.
    def test_can_recognize_strings_with_specified_substring
      start_state = 0
      accept_states = [2]
      rulebook = FiniteAutomaton::DeterministicFiniteAutomaton::RuleBook.new(rules_for_strings_with_specified_substrings)
      dfa_design = 
        FiniteAutomaton::DeterministicFiniteAutomaton::Design.new(
          start_state,
          accept_states,
          rulebook
        )
      
      assert dfa_design.accepts?('00111001')
      assert dfa_design.accepts?('01')
      refute dfa_design.accepts?('0')
      refute dfa_design.accepts?('1110')
    end
  end
end