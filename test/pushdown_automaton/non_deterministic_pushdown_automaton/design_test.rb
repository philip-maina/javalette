require './javalette'
require "minitest/autorun"
module PushdownAutomaton
  class NonDeterministicPushdownAutomaton::DesignTest < Minitest::Test
    def setup
      @start_state = 0
      @accept_states = [2]
      @stack_start_symbol = '$'
      @rulebook = PushdownAutomaton::NonDeterministicPushdownAutomaton::RuleBook.new(rules_for_even_length_palindromes)
    end


    def rules_for_even_length_palindromes
      [
        PushdownAutomaton::Rule.new(0, 'a', 0, '$', ['a', '$']),
        PushdownAutomaton::Rule.new(0, 'b', 0, '$', ['b', '$']),
        PushdownAutomaton::Rule.new(0, 'a', 0, 'a', ['a', 'a']),
        PushdownAutomaton::Rule.new(0, 'b', 0, 'b', ['b', 'b']),
        PushdownAutomaton::Rule.new(0, 'a', 0, 'b', ['a', 'b']),
        PushdownAutomaton::Rule.new(0, 'b', 0, 'a', ['b', 'a']),
        PushdownAutomaton::Rule.new(0, 'a', 1, 'a', []),
        PushdownAutomaton::Rule.new(0, 'b', 1, 'b', []),
        PushdownAutomaton::Rule.new(1, 'a', 1, 'a', []),
        PushdownAutomaton::Rule.new(1, 'b', 1, 'b', []),
        PushdownAutomaton::Rule.new(1, nil, 2, '$', ['$'])
      ]
    end

    # 𝐿 = { 𝑤𝑤𝑅｜𝑤 = (𝑎|𝑏)+ }
    def test_can_recognize_even_length_palindromes_with_recursive_backtracking_strategy
      non_deterministic_strategy = PushdownAutomaton::NonDeterministicPushdownAutomaton::Strategies::RecursiveBacktrackingStrategy.new
      npda_design = 
        PushdownAutomaton::NonDeterministicPushdownAutomaton::Design.new(
          @start_state,
          @accept_states,
          @rulebook,
          @stack_start_symbol,
          non_deterministic_strategy
        )
      
      assert npda_design.accepts?('abba')
      assert npda_design.accepts?('babbaabbab')
      refute npda_design.accepts?('abbb')
      refute npda_design.accepts?('baabaa')

      # NOTE: This is an odd length palindrome hence should not be accepted
      refute npda_design.accepts?('a')
    end

    # 𝐿 = { 𝑤𝑤𝑅｜𝑤 = (𝑎|𝑏)+ }
    def test_can_recognize_even_length_palindromes_with_state_set_strategy
      non_deterministic_strategy = PushdownAutomaton::NonDeterministicPushdownAutomaton::Strategies::StateSetStrategy.new
      npda_design = 
        PushdownAutomaton::NonDeterministicPushdownAutomaton::Design.new(
          @start_state,
          @accept_states,
          @rulebook,
          @stack_start_symbol,
          non_deterministic_strategy
        )
        
      assert npda_design.accepts?('abba')
      assert npda_design.accepts?('babbaabbab')
      refute npda_design.accepts?('abbb')
      refute npda_design.accepts?('baabaa')

      # NOTE: This is an odd length palindrome therefore should not be accepted
      refute npda_design.accepts?('a')
    end
  end
end