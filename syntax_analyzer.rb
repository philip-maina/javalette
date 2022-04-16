# Recursive Descent Parsing Algorithm
# 
# Maybe pass the algorithm as a dependency injection (strategy pattern) 
# so that we have - recursive descent, predictive parsing, bottom up parsing .....
class SyntaxAnalyzer
  attr_accessor :tokens

  # A set of productions, which are rules for replacing (or rewriting) 
  # nonterminal symbols  (on the left side of the production) with 
  # other nonterminal or terminal symbols (on the right side of the production).
  PRODUCTIONS = {
    'Prog': ['ListFnDef'],
    'ListFnDef': ['FnDef', 'ListFnDef'],
    'ListFnDef': ['FnDef'],
    'FnDef': ['Type', 'id', '(', 'ListArg', ')', 'Blk'],

    'ListArg': ['Arg', ',', 'ListArg'],
    'ListArg': ['Arg'],
    'ListArg': [],
    'Arg': ['Type', 'id'],

    'Blk': ['{', 'ListStmt', '}'],
    'ListStmt': ['Stmt', 'ListStmt'],
    'ListStmt': [],

    'Stmt': [';'],
    'Stmt': ['Blk'],
    'Stmt': ['Type', 'LisItem', ';'],
    'Stmt': ['id', '=', 'Expr', ';'],
    'Stmt': ['id', '++', ';'],
    'Stmt': ['id', '--', ';'],
    'Stmt': ['return', 'Expr', ';'],
    'Stmt': ['return', ';'],
    'Stmt': ['if', '(', 'Expr', ')', 'Stmt'],
    'Stmt': ['if', '(', 'Expr', ')', 'Stmt', 'else', 'Stmt'],
    'Stmt': ['while', '(', 'Expr', ')', 'Stmt'],
    'Stmt': ['Expr', ';'],

    'ListItem': ['id', ',', 'ListItem'],
    'ListItem': ['Item'],
    'Item': ['id', '=', 'Expr'],
    'Item': ['id'],

    'Type': ['int'],
    'Type': ['double'],
    'Type': ['boolean'],
    'Type': ['void'],

    'Expr6': ['id'],
    'Expr6': ['int_literal'],
    'Expr6': ['double_literal'],
    'Expr6': ['boolean_literal'],
    'Expr6': ['id', '(', 'ListExpr', ')'],
    'Expr6': ['string_literal'],

    'Expr5': ['-', 'Expr6'],
    'Expr5': ['!', 'Expr6'],
    'Expr5': ['Expr6'],

    'Expr4': ['Expr5', 'MulOp', 'Expr4'],
    'Expr4': ['Expr5'],

    'Expr3': ['Expr4', 'AddOp', 'Expr3'],
    'Expr3': ['Expr4'],

    'Expr2': ['Expr3', 'RelOp', 'Expr2'],
    'Expr2': ['Expr3'],

    'Expr1': ['Expr2', '&&', 'Expr1'],
    'Expr1': ['Expr2'],

    'Expr': ['Expr1', '||', 'Expr'],
    'Expr': ['Expr1'],

    'ListExpr': ['Expr', ',', 'ListExpr'],
    'ListExpr': ['Expr'],
    'ListExpr': [],

    'AddOp': ['+'],
    'AddOp': ['-'],

    'MulOp': ['*'],
    'MulOp': ['/'],
    'MulOp': ['%'],

    'RelOp': ['<'],
    'RelOp': ['<='],
    'RelOp': ['>'],
    'RelOp': ['>='],
    'RelOp': ['=='],
    'RelOp': ['!=']
  }

  def initialize(tokens)
    @tokens = tokens
  end

  def parse
    recursive_descent_parse
  end

  private
    # Mimics depth-first search algorithm
    # This is an algorithm of creating a parse tree that goes:
    #   • From top to bottom (starting with the start symbol to the program)
    #   • From left to right
    def recursive_descent_parse
      non_terminal_symbol_rules =
        PRODUCTIONS.map do |lhs_symbol, replacement_symbols|
          PushdownAutomaton::Rule.new(1, nil, 1, lhs_symbol, replacement_symbols)
        end
        
      terminal_symbol_rules = 
        LexicalAnalyzer::TOKEN_CLASSES.map do |rule| 
          PushdownAutomaton::Rule.new(1, rule[:token], 1, rule[:token], [])
        end

      rules = []
      rules.push(start_rule)
      rules.concat(non_terminal_symbol_rules)
      rules.concat(terminal_symbol_rules)
      rules.push(acceptance_rule)

      rule_book = PushDownAutomaton::NonDeterministicPushdownAutomaton::RuleBook.new(rules)
      npda_design = PushDownAutomaton::NonDeterministicPushdownAutomaton::Design.new(1, '$', [3], rulebook)
      npda_design.parse_trees(Tokens.new(tokens))
    end
    
    def bottom_up_parsing
    end

    # This is a special form of recursive descent parsing that uses a lookahead (preemptively look at the next few tokens).
    # The lookahead guides on the selection of the production to follow.
    # There is no backtracking like in non-deterministic pushdown automaton (recursive backtracking strategy)
    # This basically makes it deterministic unlike recursive descent parsing.
    def predictive_parsing
    end

    def shift_reduce_parsing
    end

    def slr_parsing
    end

    def start_rule
      PushdownAutomaton::Rule.new(0, nil, 1, '$', [PRODUCTIONS.keys.first, '$']
    end

    def acceptance_rule
      PushdownAutomaton::Rule.new(1, nil, 2, '$', ['$'])
    end

    # Duck Typing: 
    #   We need to rely less on the type (or class) of an object and more on its capabilities (what it can do - methods/operations). 
    #   In our case we need to make tokens received from the lexer to quack like a string for use in non determinitic pushdown automaton
    #   This avoids type checking.
    class Tokens
      def initialize(tokens)
        @tokens = tokens
      end

      def chars
        @tokens
      end

      def [](range)
        @tokens[range]
      end
    end
end