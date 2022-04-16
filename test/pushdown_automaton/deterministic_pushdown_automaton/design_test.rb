require './javalette'
require "minitest/autorun"
module PushdownAutomaton
  class DeterministicPushdownAutomaton::DesignTest < Minitest::Test

    def rules_for_nested_parenthesis
      [
        PushdownAutomaton::Rule.new(0, '(', 0, '$', ['(', '$']),
        PushdownAutomaton::Rule.new(0, '(', 0, '(', ['(', '(']),
        PushdownAutomaton::Rule.new(0, ')', 1, '(', []),
        PushdownAutomaton::Rule.new(1, ')', 1, '(', []),
        PushdownAutomaton::Rule.new(1, nil, 2, '$', ['$'])
      ]
    end

    def rules_for_equal_no_of_as_and_bs
      [
        PushdownAutomaton::Rule.new(0, 'a', 1, '$', ['a', '$']),
        PushdownAutomaton::Rule.new(0, 'b', 1, '$', ['b', '$']),
        PushdownAutomaton::Rule.new(1, 'a', 1, 'a', ['a', 'a']),
        PushdownAutomaton::Rule.new(1, 'b', 1, 'b', ['b', 'b']),
        PushdownAutomaton::Rule.new(1, 'a', 1, 'b', []),
        PushdownAutomaton::Rule.new(1, 'b', 1, 'a', []),
        PushdownAutomaton::Rule.new(1, nil, 2, '$', ['$']),
        PushdownAutomaton::Rule.new(2, 'a', 1, '$', ['a', '$']),
        PushdownAutomaton::Rule.new(2, 'b', 1, '$', ['b', '$'])
      ]
    end

    def rules_for_palindromes_with_unique_midpoint_character
      [
        PushdownAutomaton::Rule.new(0, 'a', 0, '$', ['a', '$']),
        PushdownAutomaton::Rule.new(0, 'b', 0, '$', ['b', '$']),
        PushdownAutomaton::Rule.new(0, 'a', 0, 'a', ['a', 'a']),
        PushdownAutomaton::Rule.new(0, 'b', 0, 'b', ['b', 'b']),
        PushdownAutomaton::Rule.new(0, 'a', 0, 'b', ['a', 'b']),
        PushdownAutomaton::Rule.new(0, 'b', 0, 'a', ['b', 'a']),
        PushdownAutomaton::Rule.new(0, 'c', 1, 'a', ['a']),
        PushdownAutomaton::Rule.new(0, 'c', 1, 'b', ['b']),
        PushdownAutomaton::Rule.new(1, 'a', 1, 'a', []),
        PushdownAutomaton::Rule.new(1, 'b', 1, 'b', []),
        PushdownAutomaton::Rule.new(1, nil, 2, '$', ['$'])
      ]
    end
    
    # L = {(ⁱ)ⁱ | i ≥ 1}. : Right paarens have to appear then left follow
    def test_can_recognize_nested_parenthesis_structure
      start_state = 0
      accept_states = [2]
      stack_start_symbol = '$'
      rulebook = PushdownAutomaton::DeterministicPushdownAutomaton::RuleBook.new(rules_for_nested_parenthesis)
      dpda_design = 
        PushdownAutomaton::DeterministicPushdownAutomaton::Design.new(
          start_state,
          accept_states,
          rulebook,
          stack_start_symbol
        )
      
      assert dpda_design.accepts?('(((((((((())))))))))')
      refute dpda_design.accepts?('())')
      refute dpda_design.accepts?('))()')
    end

    # L = {w | nₐ(w) = nb(w)} : no of a characters should equal no of b characters
    # Note: This is different from aⁿbⁿ.
    def test_can_recognize_equal_no_of_two_characters
      start_state = 0
      accept_states = [2]
      stack_start_symbol = '$'
      rulebook = PushdownAutomaton::DeterministicPushdownAutomaton::RuleBook.new(rules_for_equal_no_of_as_and_bs)
      dpda_design = 
        PushdownAutomaton::DeterministicPushdownAutomaton::Design.new(
          start_state,
          accept_states,
          rulebook,
          stack_start_symbol
        )

      assert dpda_design.accepts?('bababaab')
      assert dpda_design.accepts?('abab')
      refute dpda_design.accepts?('bab')
      refute dpda_design.accepts?('a')
    end

    # L = { wcwᴿ: w ∈ {a,b}*} 
    def test_can_recognize_palindromes_with_unique_midpoint_character
      start_state = 0
      accept_states = [2]
      stack_start_symbol = '$'
      rulebook = PushdownAutomaton::DeterministicPushdownAutomaton::RuleBook.new(rules_for_palindromes_with_unique_midpoint_character)
      dpda_design = 
        PushdownAutomaton::DeterministicPushdownAutomaton::Design.new(
          start_state,
          accept_states,
          rulebook,
          stack_start_symbol
        )
      
      assert dpda_design.accepts?('abcba')
      assert dpda_design.accepts?('babbacabbab')
      refute dpda_design.accepts?('abcb')
      refute dpda_design.accepts?('baacbaa')
    end
  end
end