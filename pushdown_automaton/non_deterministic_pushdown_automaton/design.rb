# Once a PushdownAutomaton::NonDeterministicPushdownAutomaton object has been fed some input, 
# it’s probably not in its start configuration anymore, so we can’t reliably reuse it to 
# check a completely new sequence of inputs. 
# 
# That means we have to recreate it from scratch—using the same start configuration, accept states, 
# and rule- book as before—every time we want to see whether it will accept a new string. 
# 
# We can avoid doing this manually by wrapping up its constructor’s arguments in an object 
# that represents the design of a particular DPDA and relying on that object to automatically 
# build one-off instances of that DPDA whenever we want to check for acceptance of a string
module PushdownAutomaton
  class NonDeterministicPushdownAutomaton
    class Design
      attr_accessor :start_state,
                    :accept_states,
                    :rulebook,
                    :stack_start_symbol,
                    :non_deterministic_strategy

      def initialize(
        start_state,
        accept_states,
        rulebook,
        stack_start_symbol,
        non_deterministic_strategy = ::PushdownAutomaton::NonDeterministicPushdownAutomaton::Strategies::StateSetStrategy.new
      )
        @start_state                = start_state
        @accept_states              = accept_states
        @rulebook                   = rulebook
        @stack_start_symbol         = stack_start_symbol
        @non_deterministic_strategy = non_deterministic_strategy
      end

      # tap method evaluates a block and then returns the object it was called on.
      def accepts?(string)
        to_ndpda.tap { |ndpda| ndpda.read_string(string) }.accepting?
      end

      # When moving from one configuration to the next configuration, we recorded the
      # sequence of rules followed along the way. This sequence of rules provides us
      # with enough information to build a parse tree for each accepting configuration.
      def parse_trees(string)
        trees = []
        ndpda = to_ndpda
        ndpda.read_string(string)
        if ndpda.accepting?
          accepting_configurations = ndpda.current_configurations.select { |configuration| accept_states.include?(configuration.state) }
          trees = accepting_configurations.map { |configuration| parse_tree(configuration.sequence_of_rules) }
          ap "The following tree(s) can be generated:"
          ap trees
        else
          "No Parse tree could be generated!"
        end

        trees
      end

      def to_ndpda
        start_stack = Stack.new([ stack_start_symbol ])
        start_configuration = ::PushdownAutomaton::Configuration.new(start_state, start_stack, []) 
        ::PushdownAutomaton::NonDeterministicPushdownAutomaton.new(Set[start_configuration], accept_states, rulebook, non_deterministic_strategy)
      end

      private
        # Following the sequence of rules helps us build a parse tree in a depth-first approach
        # 
        # Recap: Depth-first approach 
        #   It involves starting from a root node(s) and exploring as far as possible a single path before
        #   backtracking back to an unvisited node when one reaches a dead end.
        #   We also need to keep track of where we came from which will allow us to backtrack (through a stack data structure)
        # 
        # Implementation:
        #   1. Create a Root Node and immediately push the start symbol(first rule's pop character) as a child of the root node
        #   2. Push the root node to the top of our stack. The stack structure allows us to track the current node that we are
        #      building.
        #   3. For each rule:
        #        a. We know that the top of the stack represents the current node we are building.
        #        b. Find a node within the current node's unvisited children where the current rule's pop character is the same 
        #           as the name of the child.
        #        c. If a node exists:
        #             • Make the found node's children to be the push characters of the current rule.
        #             • Mark the found node as visited
        #             • If the found node has children, then push the found node to the top of 
        #               the stack hence making it the current node.
        #        d. If a node does not exist:
        #             • Pop the node at the top of the stack (backtracking step of dfs)
        #             • Go back to step 3a. with the same current rule. (recursion step of dfs)
        def parse_tree(rules)
          root_node = Node.new(name: :root, children: [ Node.new(name: rules.first.pop_character) ], visited: true)
          stack = Stack.new([root_node])
          rules.each { |rule| process_rule(rule, stack) }
          root_node.to_h
        end

        def process_rule(rule, stack)
          current_node = stack.top
          node = current_node.children.find { |node| !node.visited? && (rule.pop_character == node.name) }
          
          if node
            node.children = rule.push_characters.map { |push_character| Node.new(name: push_character) }
            node.visited = true
            stack.push(node) if node.children.present?
          else
            stack.pop
            process_rule(rule, stack)
          end
        end

        class Node
          attr_accessor :name, 
                        :children, 
                        :visited

          def initialize(
            name:, 
            children: [], 
            visited: false
          )
            @name     = name
            @children = children
            @visited  = visited
          end

          def visited?
            visited
          end

          def to_h
            { name: name, children: children.map(&:to_h) }
          end
        end
    end
  end
end