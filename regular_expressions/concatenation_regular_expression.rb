module RegularExpressions
  class ConcatenationRegularExpression < Struct.new(:first, :second)
    include ::RegularExpressions::Pattern

    def to_s
      [first, second].map { |pattern| pattern.bracket(precedence) }.join
    end

    # Convention for the concrete syntax of regular expressions is 
    # for the * operator to bind more tightly than concatenation, 
    # which in turn binds more tightly than the | operator. 
    def precedence 
      1
    end

    # Conversions of regexes to nfas are based on the link below
    # https://www.youtube.com/watch?v=gwGfWwNkS8I&list=PLDcmCgguL9rxPoVn2ykUFc8TOpLyDU5gx&index=15
    # and not the book
    def to_nfa_design
      first_nfa_design = first.to_nfa_design 
      second_nfa_design = second.to_nfa_design

      start_state = first_nfa_design.start_state
      accept_states = second_nfa_design.accept_states

      rules = first_nfa_design.rulebook.rules + second_nfa_design.rulebook.rules 
      epsilon_rules = 
        first_nfa_design.accept_states.map do |state| 
          ::FiniteAutomaton::Rule.new(state, nil, second_nfa_design.start_state) 
        end
      rulebook = ::FiniteAutomaton::NonDeterministicFiniteAutomaton::RuleBook.new(rules + epsilon_rules)
      
      ::FiniteAutomaton::NonDeterministicFiniteAutomaton::Design.new(
        start_state, 
        accept_states, 
        rulebook
      ) 
    end
  end
end


# RegularExpressions::ConcatenationRegularExpression.new(
#   RegularExpressions::LiteralRegularExpression.new('1'),
#   RegularExpressions::ConcatenationRegularExpression.new(
#     RegularExpressions::LiteralRegularExpression.new('2'),
#     RegularExpressions::ConcatenationRegularExpression.new(
#       RegularExpressions::LiteralRegularExpression.new('3'),
#       RegularExpressions::LiteralRegularExpression.new('4')
#     )
#   )
# )
# => /1234/ 