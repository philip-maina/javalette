module SyntaxProductionRules
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  def symbol_rules
    [
      PushdownAutomaton::Rule.new(0, nil, 1, '$', ['Prog', '$']),
    
      PushdownAutomaton::Rule.new(1, nil, 1, 'Prog'     , ['ListFnDef']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'ListFnDef', ['FnDef', 'ListFnDef']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'ListFnDef', ['FnDef']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'FnDef'    , ['Type', 'id', '(', 'ListArg', ')', 'Blk']),
    
      PushdownAutomaton::Rule.new(1, nil, 1, 'ListArg', ['Arg', ',', 'ListArg']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'ListArg', ['Arg']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'ListArg', []),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Arg'    , ['Type', 'id']),
    
      PushdownAutomaton::Rule.new(1, nil, 1, 'Blk'     , ['{', 'ListStmt', '}']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'ListStmt', ['Stmt', 'ListStmt']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'ListStmt', []),
    
      PushdownAutomaton::Rule.new(1, nil, 1, 'Stmt', [';']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Stmt', ['Blk']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Stmt', ['Type', 'LisItem', ';']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Stmt', ['id', '=', 'Expr', ';']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Stmt', ['id', '++', ';']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Stmt', ['id', '--', ';']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Stmt', ['return', 'Expr', ';']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Stmt', ['return', ';']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Stmt', ['if', '(', 'Expr', ')', 'Stmt']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Stmt', ['if', '(', 'Expr', ')', 'Stmt', 'else', 'Stmt']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Stmt', ['while', '(', 'Expr', ')', 'Stmt']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Stmt', ['Expr', ';']),
    
      PushdownAutomaton::Rule.new(1, nil, 1, 'ListItem', ['id', ',', 'ListItem']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'ListItem', ['Item']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Item'    , ['id', '=', 'Expr']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Item'    , ['id']),
    
      PushdownAutomaton::Rule.new(1, nil, 1, 'Type', ['int']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Type', ['double']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Type', ['boolean']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Type', ['void']),
    
      PushdownAutomaton::Rule.new(1, nil, 1, 'Expr6', ['id']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Expr6', ['int_literal']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Expr6', ['double_literal']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Expr6', ['boolean_literal']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Expr6', ['id', '(', 'ListExpr', ')']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Expr6', ['string_literal']),
    
      PushdownAutomaton::Rule.new(1, nil, 1, 'Expr5', ['-', 'Expr6']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Expr5', ['!', 'Expr6']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Expr5', ['Expr6']),
    
      PushdownAutomaton::Rule.new(1, nil, 1, 'Expr4', ['Expr5', 'MulOp', 'Expr4']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Expr4', ['Expr5']),
    
      PushdownAutomaton::Rule.new(1, nil, 1, 'Expr3', ['Expr4', 'AddOp', 'Expr3']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Expr3', ['Expr4']),
    
      PushdownAutomaton::Rule.new(1, nil, 1, 'Expr2', ['Expr3', 'RelOp', 'Expr2']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Expr2', ['Expr3']),
    
      PushdownAutomaton::Rule.new(1, nil, 1, 'Expr1', ['Expr2', '&&', 'Expr1']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Expr1', ['Expr2']),
    
      PushdownAutomaton::Rule.new(1, nil, 1, 'Expr', ['Expr1', '||', 'Expr']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'Expr', ['Expr1']),
    
      PushdownAutomaton::Rule.new(1, nil, 1, 'ListExpr', ['Expr', ',', 'ListExpr']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'ListExpr', ['Expr']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'ListExpr', []),
    
      PushdownAutomaton::Rule.new(1, nil, 1, 'AddOp', ['+']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'AddOp', ['-']),
    
      PushdownAutomaton::Rule.new(1, nil, 1, 'MulOp', ['*']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'MulOp', ['/']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'MulOp', ['%']),
    
      PushdownAutomaton::Rule.new(1, nil, 1, 'RelOp', ['<']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'RelOp', ['<=']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'RelOp', ['>']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'RelOp', ['>=']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'RelOp', ['==']),
      PushdownAutomaton::Rule.new(1, nil, 1, 'RelOp', ['!='])
    ]
  end

  def token_rules
    LexicalAnalyzer::TOKEN_CLASSES.map do |rule| 
      PushdownAutomaton::Rule.new(1, rule[:token], 1, rule[:token], [])
    end
  end

  def acceptance_rule
    PushdownAutomaton::Rule.new(1, nil, 2, '$', ['$'])
  end
end