module RegularExpressions
  module Pattern
    # If the inner/nested regular expression has lower precedence
    # than the one wrapping it (outer) then wrap the inner with brackets.
    def bracket(outer_precedence)
      precedence < outer_precedence ? '(' + to_s + ')' : to_s
    end

    # In string interpolation, ruby calls to_s on the object of concern.
    def inspect 
      "/#{self}/"
    end

    # Converts regex to nfa and checks if string is in language
    def matches?(string)
      to_nfa_design.accepts?(string) 
    end

    # Finds substring within provided string that matches the pattern
    # Return characters matched so far (longest match)
    # e.g   
    #   ConcatenationRegularExpression.new(
    #     LiteralRegularExpression.new('i'),
    #     LiteralRegularExpression.new('f')
    #   ).match("if (a == b)") => "if"
    def match(string)
      matched_substrings = []
      string.length.times do |idx| 
        substring = string[0..idx]
        matched_substrings.push(substring) if matches?(substring) 
      end
      matched_substrings.max_by(&:length) 
    end
  end
end