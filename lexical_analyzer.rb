class LexicalAnalyzer
  include LexicalPatterns
  attr_accessor :string

  TOKEN_CLASSES = [
    # KEYWORDS
    { token: 'if'     , pattern: if_keyword_pattern      },
    { token: 'while'  , pattern: while_keyword_pattern   },
    { token: 'return' , pattern: return_keyword_pattern  },
    { token: 'else'   , pattern: else_keyword_pattern    },
    { token: 'int'    , pattern: int_keyword_pattern     },
    { token: 'double' , pattern: double_keyword_pattern  },
    { token: 'boolean', pattern: boolean_keyword_pattern },
    { token: 'void'   , pattern: void_keyword_pattern    },
 
    # LITERALS      
    { token: 'int_literal'    , pattern: integer_literal_pattern },
    { token: 'double_literal' , pattern: double_literal_pattern   },
    { token: 'boolean_literal', pattern: boolean_literal_pattern  },
    { token: 'string_literal' , pattern: string_literal_pattern   },
 
    # SPECIAL CHARACTERS
    { token: '(', pattern: open_parenthesis_literal_pattern  },
    { token: ')', pattern: close_parenthesis_literal_pattern },
    { token: '{', pattern: open_brace_literal_pattern        },
    { token: '}', pattern: close_brace_literal_pattern       },
    { token: ';', pattern: terminator_literal_pattern        },
    { token: ',', pattern: separator_literal_pattern         },

    # ARITHMETIC OPERATORS
    { token: '+', pattern: addition_operator_literal_pattern       },
    { token: '-', pattern: subtraction_operator_literal_pattern    },
    { token: '*', pattern: multiplication_operator_literal_pattern },
    { token: '/', pattern: division_operator_literal_pattern       },
    { token: '%', pattern: modulus_operator_literal_pattern        },

    # INCREMENT/DECREMENT OPERATORS
    { token: '++', pattern: post_increment_literal_pattern },
    { token: '--', pattern: post_decrement_literal_pattern },

    # ASSIGNMENT OPERATOR
    { token: '=', pattern: assignment_literal_pattern },

    # LOGICAL OPERATORS
    { token: '!' , pattern: logical_not_literal_pattern },
    { token: '&&', pattern: logical_and_literal_pattern },
    { token: '||', pattern: logical_or_literal_pattern  },

    # RELATIONAL OPERATORS
    { token: '<' , pattern: less_than_literal_pattern                },
    { token: '<=', pattern: less_than_or_equal_to_literal_pattern    },
    { token: '>' , pattern: greater_than_literal_pattern             },
    { token: '>=', pattern: greater_than_or_equal_to_literal_pattern },
    { token: '==', pattern: equal_to_literal_pattern                 },
    { token: '!=', pattern: not_equal_to_literal_pattern             },


    # IDENTIFIER/VARIABLE 
    { token: 'id' , pattern: identifier_pattern }

  ]

  def initialize(string)
    @string = string.strip
  end

  def tokenize
    tokens = []
    while !string.empty?
      tokens.push(next_token)
    end

    tokens
  end

  def next_token
    token_class, match = token_class_matching(string) 
    self.string = string_after(match) 
    token_class[:token]
  end

  def token_class_matching(string)
    matches = TOKEN_CLASSES.map { |token_class| match_at_beginning(token_class[:pattern], string) } 
    token_classes_with_matches = TOKEN_CLASSES.zip(matches).reject { |token_class, match| match.nil? } 
    maximal_munch_token_class(token_classes_with_matches)
  end

  def match_at_beginning(pattern, string)
    pattern.match(string)
  end

  def maximal_munch_token_class(token_classes_with_matches)
    token_classes_with_matches.max_by { |rule, match| match.to_s.length }
  end

  def string_after(match)
    string.gsub(/^#{Regexp.escape(match)}/, '').lstrip
  end
end