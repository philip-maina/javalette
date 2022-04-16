module RegularExpressions
  class LiteralRegularExpression < Struct.new(:character)
    include ::RegularExpressions::Pattern

    def to_s 
      character
    end

    def precedence 
      3
    end

    # Conversions of regexes to nfas are based on the link below
    # https://www.youtube.com/watch?v=gwGfWwNkS8I&list=PLDcmCgguL9rxPoVn2ykUFc8TOpLyDU5gx&index=15
    # and not the book
    def to_nfa_design
      start_state = Object.new 
      accept_state = Object.new

      rule = ::FiniteAutomaton::Rule.new(start_state, character, accept_state) 
      rulebook = ::FiniteAutomaton::NonDeterministicFiniteAutomaton::RuleBook.new([rule])
      
      ::FiniteAutomaton::NonDeterministicFiniteAutomaton::Design.new(
        start_state, 
        [accept_state], 
        rulebook
      ) 
    end
  end
end