module RegularExpressions
  class UnionRegularExpression < Struct.new(:first, :second)
    include ::RegularExpressions::Pattern

    # No need to do `pattern.bracket(precedence)`` because union has the lowest
    # precedence so nothing nested will be bracketed. 
    def to_s
      [first, second].map { |pattern| pattern.to_s }.join('|')
    end

    # Convention for the concrete syntax of regular expressions is 
    # for the * operator to bind more tightly than concatenation, 
    # which in turn binds more tightly than the | operator. 
    def precedence 
      0
    end

    # Conversions of regexes to nfas are based on the link below
    # https://www.youtube.com/watch?v=gwGfWwNkS8I&list=PLDcmCgguL9rxPoVn2ykUFc8TOpLyDU5gx&index=15
    # and not the book
    def to_nfa_design
      first_nfa_design = first.to_nfa_design 
      second_nfa_design = second.to_nfa_design

      start_state = Object.new 
      accept_state = Object.new

      rules = first_nfa_design.rulebook.rules + second_nfa_design.rulebook.rules
      epsilon_rules = 
        [first_nfa_design, second_nfa_design].reduce([]) do |arr, nfa_design|
          arr.push(::FiniteAutomaton::Rule.new(start_state, nil, nfa_design.start_state))
          arr + nfa_design.accept_states.map { |state| ::FiniteAutomaton::Rule.new(state, nil, accept_state) }
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


# RegularExpressions::UnionRegularExpression.new(
#   RegularExpressions::LiteralRegularExpression.new('1'),
#   RegularExpressions::UnionRegularExpression.new(
#     RegularExpressions::LiteralRegularExpression.new('2'),
#     RegularExpressions::UnionRegularExpression.new(
#       RegularExpressions::LiteralRegularExpression.new('3'),
#       RegularExpressions::LiteralRegularExpression.new('4')
#     )
#   )
# )
# => /1|2|3|4/