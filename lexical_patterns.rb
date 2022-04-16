module LexicalPatterns
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def digit_pattern
      RegularExpressions::UnionRegularExpression.new(
        RegularExpressions::LiteralRegularExpression.new('0'),
        RegularExpressions::UnionRegularExpression.new(
          RegularExpressions::LiteralRegularExpression.new('1'),
          RegularExpressions::UnionRegularExpression.new(
            RegularExpressions::LiteralRegularExpression.new('2'),
            RegularExpressions::UnionRegularExpression.new(
              RegularExpressions::LiteralRegularExpression.new('3'),
              RegularExpressions::UnionRegularExpression.new(
                RegularExpressions::LiteralRegularExpression.new('4'),
                RegularExpressions::UnionRegularExpression.new(
                  RegularExpressions::LiteralRegularExpression.new('5'),
                  RegularExpressions::UnionRegularExpression.new(
                    RegularExpressions::LiteralRegularExpression.new('6'),
                    RegularExpressions::UnionRegularExpression.new(
                      RegularExpressions::LiteralRegularExpression.new('7'),
                      RegularExpressions::UnionRegularExpression.new(
                        RegularExpressions::LiteralRegularExpression.new('8'),
                        RegularExpressions::LiteralRegularExpression.new('9')
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
    end

    # JAVALETTE NUMBER LITERALS
    def integer_literal_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        digit_pattern,
        RegularExpressions::IterationRegularExpression.new(digit_pattern)
      )
    end

    def scientific_notation_fractional_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        integer_literal_pattern,
        RegularExpressions::ConcatenationRegularExpression.new(
          RegularExpressions::UnionRegularExpression.new(
            RegularExpressions::LiteralRegularExpression.new('e'),
            RegularExpressions::LiteralRegularExpression.new('E')
          ),
          RegularExpressions::UnionRegularExpression.new(
            integer_literal_pattern,
            RegularExpressions::ConcatenationRegularExpression.new(
              RegularExpressions::UnionRegularExpression.new(
                RegularExpressions::LiteralRegularExpression.new('-'),
                RegularExpressions::LiteralRegularExpression.new('+')
              ),
              integer_literal_pattern
            )
          )
        )
      )
    end


    # The number before the decimal point is called the whole part or integer part ,
    # Whereas the number after the decimal point is called the fractional part .
    def fractional_pattern
      RegularExpressions::UnionRegularExpression.new(
        integer_literal_pattern,
        scientific_notation_fractional_pattern
      )
    end


    # JAVALETTE DOUBLE LITERALS
    def double_literal_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        integer_literal_pattern,
        RegularExpressions::ConcatenationRegularExpression.new(
          RegularExpressions::LiteralRegularExpression.new('.'),
          fractional_pattern
        )
      )
    end


    # JAVALETTE BOOLEAN LITERALS
    def true_literal_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        RegularExpressions::LiteralRegularExpression.new('t'),
        RegularExpressions::ConcatenationRegularExpression.new(
          RegularExpressions::LiteralRegularExpression.new('r'),
          RegularExpressions::ConcatenationRegularExpression.new(
            RegularExpressions::LiteralRegularExpression.new('u'),
            RegularExpressions::LiteralRegularExpression.new('e')
          )
        )
      )
    end

    
    def false_literal_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        RegularExpressions::LiteralRegularExpression.new('f'),
        RegularExpressions::ConcatenationRegularExpression.new(
          RegularExpressions::LiteralRegularExpression.new('a'),
          RegularExpressions::ConcatenationRegularExpression.new(
            RegularExpressions::LiteralRegularExpression.new('l'),
            RegularExpressions::ConcatenationRegularExpression.new(
              RegularExpressions::LiteralRegularExpression.new('s'),
              RegularExpressions::LiteralRegularExpression.new('e')
            )
          )
        )
      )
    end

    def boolean_literal_pattern
      RegularExpressions::UnionRegularExpression.new(
        true_literal_pattern,
        false_literal_pattern
      )
    end


    # KEYWORD PATTERNS: (Different pattern for each keyword)
    # a) Flow Control
    def if_keyword_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        RegularExpressions::LiteralRegularExpression.new('i'),
        RegularExpressions::LiteralRegularExpression.new('f')
      )
    end

    def while_keyword_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        RegularExpressions::LiteralRegularExpression.new('w'),
        RegularExpressions::ConcatenationRegularExpression.new(
          RegularExpressions::LiteralRegularExpression.new('h'),
          RegularExpressions::ConcatenationRegularExpression.new(
            RegularExpressions::LiteralRegularExpression.new('i'),
            RegularExpressions::ConcatenationRegularExpression.new(
              RegularExpressions::LiteralRegularExpression.new('l'),
              RegularExpressions::LiteralRegularExpression.new('e')
            )
          )
        ) 
      )
    end


    def return_keyword_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        RegularExpressions::LiteralRegularExpression.new('r'),
        RegularExpressions::ConcatenationRegularExpression.new(
          RegularExpressions::LiteralRegularExpression.new('e'),
          RegularExpressions::ConcatenationRegularExpression.new(
            RegularExpressions::LiteralRegularExpression.new('t'),
            RegularExpressions::ConcatenationRegularExpression.new(
              RegularExpressions::LiteralRegularExpression.new('u'),
              RegularExpressions::ConcatenationRegularExpression.new(
                RegularExpressions::LiteralRegularExpression.new('r'),
                RegularExpressions::LiteralRegularExpression.new('n')
              )
            )
          )
        )  
      )
    end

    def else_keyword_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        RegularExpressions::LiteralRegularExpression.new('e'),
        RegularExpressions::ConcatenationRegularExpression.new(
          RegularExpressions::LiteralRegularExpression.new('l'),
          RegularExpressions::ConcatenationRegularExpression.new(
            RegularExpressions::LiteralRegularExpression.new('s'),
            RegularExpressions::LiteralRegularExpression.new('e')
          )
        )  
      )
    end


    # b) Type Initialization
    def void_keyword_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        RegularExpressions::LiteralRegularExpression.new('v'),
        RegularExpressions::ConcatenationRegularExpression.new(
          RegularExpressions::LiteralRegularExpression.new('o'),
          RegularExpressions::ConcatenationRegularExpression.new(
            RegularExpressions::LiteralRegularExpression.new('i'),
            RegularExpressions::LiteralRegularExpression.new('d')
          )
        ) 
      )
    end

    def int_keyword_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        RegularExpressions::LiteralRegularExpression.new('i'),
        RegularExpressions::ConcatenationRegularExpression.new(
          RegularExpressions::LiteralRegularExpression.new('n'),
          RegularExpressions::LiteralRegularExpression.new('t')
        )
      )
    end

    def double_keyword_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        RegularExpressions::LiteralRegularExpression.new('d'),
        RegularExpressions::ConcatenationRegularExpression.new(
          RegularExpressions::LiteralRegularExpression.new('o'),
          RegularExpressions::ConcatenationRegularExpression.new(
            RegularExpressions::LiteralRegularExpression.new('u'),
            RegularExpressions::ConcatenationRegularExpression.new(
              RegularExpressions::LiteralRegularExpression.new('b'),
              RegularExpressions::ConcatenationRegularExpression.new(
                RegularExpressions::LiteralRegularExpression.new('l'),
                RegularExpressions::LiteralRegularExpression.new('e')
              )
            )
          )
        )  
      )
    end

    def boolean_keyword_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        RegularExpressions::LiteralRegularExpression.new('b'),
        RegularExpressions::ConcatenationRegularExpression.new(
          RegularExpressions::LiteralRegularExpression.new('o'),
          RegularExpressions::ConcatenationRegularExpression.new(
            RegularExpressions::LiteralRegularExpression.new('o'),
            RegularExpressions::ConcatenationRegularExpression.new(
              RegularExpressions::LiteralRegularExpression.new('l'),
              RegularExpressions::ConcatenationRegularExpression.new(
                RegularExpressions::LiteralRegularExpression.new('e'),
                RegularExpressions::ConcatenationRegularExpression.new(
                  RegularExpressions::LiteralRegularExpression.new('a'),
                  RegularExpressions::LiteralRegularExpression.new('n')
                )
              )
            )
          )
        )
      )
    end



    # https://www.hackerearth.com/practice/basic-programming/operators/basics-of-operators/tutorial/

    # ASSIGNMENT OPERATOR PATTERNS
    def assignment_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('=')
    end

    # BITWISE OPERATOR PATTERNS
    def bitwise_and_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('&')
    end


    def bitwise_or_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('|')
    end


    # LOGICAL OPERATOR PATTERNS - logical AND (&&), logical OR (||), logical NOT (!)
    def logical_not_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('!')
    end

    def logical_and_literal_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        bitwise_and_literal_pattern,
        bitwise_and_literal_pattern
      )
    end

    def logical_or_literal_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        bitwise_or_literal_pattern,
        bitwise_or_literal_pattern
      )
    end


    # RELATIONAL OPERATORS PATTERNS
    def less_than_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('<')
    end

    def less_than_or_equal_to_literal_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        less_than_literal_pattern,
        assignment_literal_pattern
      )
    end

    def greater_than_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('>')
    end

    def greater_than_or_equal_to_literal_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        greater_than_literal_pattern,
        assignment_literal_pattern
      )
    end

    def equal_to_literal_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        assignment_literal_pattern,
        assignment_literal_pattern
      )
    end

    def not_equal_to_literal_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        logical_not_literal_pattern,
        assignment_literal_pattern
      )
    end



    # ARITHMETIC OPERATOR PATTERNS
    def addition_operator_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('+')
    end

    def subtraction_operator_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('-')
    end

    def multiplication_operator_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('*')
    end

    def division_operator_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('/')
    end

    def modulus_operator_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('%')
    end


    # INCREMENT/DECREMENT OPERATOR PATTERNS
    def post_increment_literal_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        addition_operator_literal_pattern,
        addition_operator_literal_pattern
      )
    end

    def post_decrement_literal_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        subtraction_operator_literal_pattern,
        subtraction_operator_literal_pattern
      )
    end


    # SEPARATOR PATTERN
    def separator_literal_pattern
      RegularExpressions::LiteralRegularExpression.new(',')
    end

    # TERMINATOR PATTERN
    def terminator_literal_pattern
      RegularExpressions::LiteralRegularExpression.new(';')
    end



    # OPEN/CLOSE BRACE PATTERN
    def open_brace_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('{')
    end

    def close_brace_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('}')
    end



    # OPEN/CLOSE PARENTHESIS PATTERN 
    def open_parenthesis_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('(')
    end

    def close_parenthesis_literal_pattern
      RegularExpressions::LiteralRegularExpression.new(')')
    end




    # OTHER SPECIAL CHARACTERS 
    def whitespace_literal_pattern
      RegularExpressions::LiteralRegularExpression.new(' ')
    end

    def pound_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('#')
    end


    def dollar_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('$')
    end

    def fullstop_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('.')
    end

    def colon_literal_pattern
      RegularExpressions::LiteralRegularExpression.new(':')
    end

    def question_mark_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('?')
    end

    def at_symbol_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('@')
    end

    def open_square_bracket_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('[')
    end 

    def close_square_bracket_literal_pattern
      RegularExpressions::LiteralRegularExpression.new(']')
    end

    def circumflex_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('^')
    end

    def underscore_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('_')
    end

    def backtick_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('`')
    end

    def tilde_literal_pattern
      RegularExpressions::LiteralRegularExpression.new('~')
    end

    def apostrophe_literal_pattern
      RegularExpressions::LiteralRegularExpression.new("'")
    end

    def backslash_literal_pattern
      RegularExpressions::LiteralRegularExpression.new("\\")
    end

    def double_quotes_literal_pattern
      RegularExpressions::LiteralRegularExpression.new("\"")
    end

    def escaped_double_quotes_literal_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        backslash_literal_pattern,
        double_quotes_literal_pattern
      )
    end


    # STRING LITERALS
    def lowercase_letter_literal_pattern
      RegularExpressions::UnionRegularExpression.new(
        RegularExpressions::LiteralRegularExpression.new('a'),
        RegularExpressions::UnionRegularExpression.new(
          RegularExpressions::LiteralRegularExpression.new('b'),
          RegularExpressions::UnionRegularExpression.new(
            RegularExpressions::LiteralRegularExpression.new('c'),
            RegularExpressions::UnionRegularExpression.new(
              RegularExpressions::LiteralRegularExpression.new('d'),
              RegularExpressions::UnionRegularExpression.new(
                RegularExpressions::LiteralRegularExpression.new('e'),
                RegularExpressions::UnionRegularExpression.new(
                  RegularExpressions::LiteralRegularExpression.new('f'),
                  RegularExpressions::UnionRegularExpression.new(
                    RegularExpressions::LiteralRegularExpression.new('g'),
                    RegularExpressions::UnionRegularExpression.new(
                      RegularExpressions::LiteralRegularExpression.new('h'),
                      RegularExpressions::UnionRegularExpression.new(
                        RegularExpressions::LiteralRegularExpression.new('i'),
                        RegularExpressions::UnionRegularExpression.new(
                          RegularExpressions::LiteralRegularExpression.new('j'),
                          RegularExpressions::UnionRegularExpression.new(
                            RegularExpressions::LiteralRegularExpression.new('k'),
                            RegularExpressions::UnionRegularExpression.new(
                              RegularExpressions::LiteralRegularExpression.new('l'),
                              RegularExpressions::UnionRegularExpression.new(
                                RegularExpressions::LiteralRegularExpression.new('m'),
                                RegularExpressions::UnionRegularExpression.new(
                                  RegularExpressions::LiteralRegularExpression.new('n'),
                                  RegularExpressions::UnionRegularExpression.new(
                                    RegularExpressions::LiteralRegularExpression.new('o'),
                                    RegularExpressions::UnionRegularExpression.new(
                                      RegularExpressions::LiteralRegularExpression.new('p'),
                                      RegularExpressions::UnionRegularExpression.new(
                                        RegularExpressions::LiteralRegularExpression.new('q'),
                                        RegularExpressions::UnionRegularExpression.new(
                                          RegularExpressions::LiteralRegularExpression.new('r'),
                                          RegularExpressions::UnionRegularExpression.new(
                                            RegularExpressions::LiteralRegularExpression.new('s'),
                                            RegularExpressions::UnionRegularExpression.new(
                                              RegularExpressions::LiteralRegularExpression.new('t'),
                                              RegularExpressions::UnionRegularExpression.new(
                                                RegularExpressions::LiteralRegularExpression.new('u'),
                                                RegularExpressions::UnionRegularExpression.new(
                                                  RegularExpressions::LiteralRegularExpression.new('v'),
                                                  RegularExpressions::UnionRegularExpression.new(
                                                    RegularExpressions::LiteralRegularExpression.new('w'),
                                                    RegularExpressions::UnionRegularExpression.new(
                                                      RegularExpressions::LiteralRegularExpression.new('x'),
                                                      RegularExpressions::UnionRegularExpression.new(
                                                        RegularExpressions::LiteralRegularExpression.new('y'),
                                                        RegularExpressions::LiteralRegularExpression.new('z'),
                                                      )
                                                    )
                                                  )
                                                )
                                              )
                                            )
                                          )
                                        )
                                      )
                                    )
                                  )
                                )
                              )
                            )
                          )
                        )    
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
    end

    def uppercase_letter_literal_pattern
      RegularExpressions::UnionRegularExpression.new(
        RegularExpressions::LiteralRegularExpression.new('A'),
        RegularExpressions::UnionRegularExpression.new(
          RegularExpressions::LiteralRegularExpression.new('B'),
          RegularExpressions::UnionRegularExpression.new(
            RegularExpressions::LiteralRegularExpression.new('C'),
            RegularExpressions::UnionRegularExpression.new(
              RegularExpressions::LiteralRegularExpression.new('D'),
              RegularExpressions::UnionRegularExpression.new(
                RegularExpressions::LiteralRegularExpression.new('E'),
                RegularExpressions::UnionRegularExpression.new(
                  RegularExpressions::LiteralRegularExpression.new('F'),
                  RegularExpressions::UnionRegularExpression.new(
                    RegularExpressions::LiteralRegularExpression.new('G'),
                    RegularExpressions::UnionRegularExpression.new(
                      RegularExpressions::LiteralRegularExpression.new('H'),
                      RegularExpressions::UnionRegularExpression.new(
                        RegularExpressions::LiteralRegularExpression.new('I'),
                        RegularExpressions::UnionRegularExpression.new(
                          RegularExpressions::LiteralRegularExpression.new('J'),
                          RegularExpressions::UnionRegularExpression.new(
                            RegularExpressions::LiteralRegularExpression.new('K'),
                            RegularExpressions::UnionRegularExpression.new(
                              RegularExpressions::LiteralRegularExpression.new('L'),
                              RegularExpressions::UnionRegularExpression.new(
                                RegularExpressions::LiteralRegularExpression.new('M'),
                                RegularExpressions::UnionRegularExpression.new(
                                  RegularExpressions::LiteralRegularExpression.new('N'),
                                  RegularExpressions::UnionRegularExpression.new(
                                    RegularExpressions::LiteralRegularExpression.new('O'),
                                    RegularExpressions::UnionRegularExpression.new(
                                      RegularExpressions::LiteralRegularExpression.new('P'),
                                      RegularExpressions::UnionRegularExpression.new(
                                        RegularExpressions::LiteralRegularExpression.new('Q'),
                                        RegularExpressions::UnionRegularExpression.new(
                                          RegularExpressions::LiteralRegularExpression.new('R'),
                                          RegularExpressions::UnionRegularExpression.new(
                                            RegularExpressions::LiteralRegularExpression.new('S'),
                                            RegularExpressions::UnionRegularExpression.new(
                                              RegularExpressions::LiteralRegularExpression.new('T'),
                                              RegularExpressions::UnionRegularExpression.new(
                                                RegularExpressions::LiteralRegularExpression.new('U'),
                                                RegularExpressions::UnionRegularExpression.new(
                                                  RegularExpressions::LiteralRegularExpression.new('V'),
                                                  RegularExpressions::UnionRegularExpression.new(
                                                    RegularExpressions::LiteralRegularExpression.new('W'),
                                                    RegularExpressions::UnionRegularExpression.new(
                                                      RegularExpressions::LiteralRegularExpression.new('X'),
                                                      RegularExpressions::UnionRegularExpression.new(
                                                        RegularExpressions::LiteralRegularExpression.new('Y'),
                                                        RegularExpressions::LiteralRegularExpression.new('Z'),
                                                      )
                                                    )
                                                  )
                                                )
                                              )
                                            )
                                          )
                                        )
                                      )
                                    )
                                  )
                                )
                              )
                            )
                          )
                        )    
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
    end

    def letter_range_pattern
      RegularExpressions::UnionRegularExpression.new(
        lowercase_letter_literal_pattern,
        uppercase_letter_literal_pattern
      )
    end

    def letter_literal_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        letter_range_pattern,
        RegularExpressions::IterationRegularExpression.new(letter_range_pattern)
      )    
    end

    # A letter followed by an optional sequence of letters, digits, and underscores.
    def identifier_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        letter_range_pattern,
        RegularExpressions::IterationRegularExpression.new(
          RegularExpressions::UnionRegularExpression.new(
            letter_range_pattern,
            RegularExpressions::UnionRegularExpression.new(
              digit_pattern,
              underscore_literal_pattern
            )
          )
        )
      )    
    end


    # [^"]
    def non_double_quotes_literal_pattern
      non_double_quotes_literal_patterns = [
        letter_range_pattern,
        digit_pattern,
        assignment_literal_pattern,
        bitwise_and_literal_pattern,
        bitwise_or_literal_pattern,
        logical_not_literal_pattern,
        less_than_literal_pattern,
        greater_than_literal_pattern,
        addition_operator_literal_pattern,
        subtraction_operator_literal_pattern,
        multiplication_operator_literal_pattern,
        division_operator_literal_pattern,
        modulus_operator_literal_pattern,
        separator_literal_pattern,
        terminator_literal_pattern,
        open_brace_literal_pattern,
        close_brace_literal_pattern,
        open_parenthesis_literal_pattern,
        close_parenthesis_literal_pattern,
        pound_literal_pattern,
        dollar_literal_pattern,
        fullstop_literal_pattern,
        colon_literal_pattern,
        question_mark_literal_pattern,
        at_symbol_literal_pattern,
        open_square_bracket_literal_pattern,
        close_square_bracket_literal_pattern,
        circumflex_literal_pattern,
        underscore_literal_pattern,
        backtick_literal_pattern,
        tilde_literal_pattern,
        apostrophe_literal_pattern,
        backslash_literal_pattern,
        whitespace_literal_pattern
      ]

      non_double_quotes_literal_pattern = 
        RegularExpressions::UnionRegularExpression.new(
          non_double_quotes_literal_patterns[0],
          non_double_quotes_literal_patterns[1]
        )

      non_double_quotes_literal_patterns[2..-1].each do |pattern|
        non_double_quotes_literal_pattern = 
          RegularExpressions::UnionRegularExpression.new(
            non_double_quotes_literal_pattern,
            pattern
          )
      end
      
      return non_double_quotes_literal_pattern
    end
    
    # "([^"]|\")*" same as /"(a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|0|1|2|3|4|5|6|7|8|9|=|&|||!|<|>|+|-|*|/|%|,|;|{|}|(|)|#|$|.|:|?|@|[|]|^|_|`|~|'|\|\")*"/ 
    def string_literal_pattern
      RegularExpressions::ConcatenationRegularExpression.new(
        double_quotes_literal_pattern,
        RegularExpressions::ConcatenationRegularExpression.new(
          RegularExpressions::IterationRegularExpression.new(
            RegularExpressions::UnionRegularExpression.new(
              non_double_quotes_literal_pattern,
              escaped_double_quotes_literal_pattern
            )
          ),
          double_quotes_literal_pattern
        )
      )
    end
  end
end