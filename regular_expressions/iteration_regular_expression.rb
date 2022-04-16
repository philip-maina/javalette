module RegularExpressions
  class IterationRegularExpression < Struct.new(:pattern)
    include ::RegularExpressions::Pattern

    def to_s 
      pattern.bracket(precedence) + '*'
    end

    # Convention for the concrete syntax of regular expressions is 
    # for the * operator to bind more tightly than concatenation, 
    # which in turn binds more tightly than the | operator. 
    def precedence 
      2
    end

    def to_nfa_design
      pattern_nfa_design = pattern.to_nfa_design

      start_state = Object.new
      accept_state = Object.new

      rules = pattern_nfa_design.rulebook.rules
      epsilon_rules = []
      epsilon_rules.push(::FiniteAutomaton::Rule.new(start_state, nil, pattern_nfa_design.start_state))
      epsilon_rules.push(::FiniteAutomaton::Rule.new(start_state, nil, accept_state))
      pattern_nfa_design.accept_states.each do |state|
        epsilon_rules.push(::FiniteAutomaton::Rule.new(state, nil, start_state))
        epsilon_rules.push(::FiniteAutomaton::Rule.new(state, nil, accept_state))
      end
      rulebook = ::FiniteAutomaton::NonDeterministicFiniteAutomaton::RuleBook.new(rules + epsilon_rules)

      ::FiniteAutomaton::NonDeterministicFiniteAutomaton::Design.new(
        start_state, 
        [accept_state], 
        rulebook
      ) 
    end
  end
end

# RegularExpressions::IterationRegularExpression.new(
#   RegularExpressions::UnionRegularExpression.new(
#     RegularExpressions::ConcatenationRegularExpression.new(
#       RegularExpressions::LiteralRegularExpression.new('a'),
#       RegularExpressions::LiteralRegularExpression.new('b')
#     ),
#     RegularExpressions::LiteralRegularExpression.new('a')
#   )
# )
# => /(ab|a)*/ 