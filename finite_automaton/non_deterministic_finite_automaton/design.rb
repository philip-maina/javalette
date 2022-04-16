# As we saw with the DFA class, it’s convenient to use an NFADesign object to 
# automatically manufacture new NFA instances on demand rather than creating them manually
require 'set'

module FiniteAutomaton
  class NonDeterministicFiniteAutomaton
    class Design < Struct.new(:start_state, :accept_states, :rulebook)
      # tap method evaluates a block and then returns the object it was called on.
      def accepts?(string)
        to_nfa.tap { |nfa| nfa.read_string(string) }.accepting?
      end

      def to_nfa(current_states = Set[start_state])
        NonDeterministicFiniteAutomaton.new(current_states, accept_states.to_set, rulebook) 
      end

      # Systematically explore the simulation states and record discoveries (https://www.youtube.com/watch?v=MWVMsk-A-Fg)
      # as the states and rules of a DFA.
      # Breadth first exploration:
      #   1. Start by putting any one of the graph's vertices at the back of a queue.
      #   2. Take the front item of the queue and add it to the visited list.
      #   3. Create a list of that vertex's adjacent nodes. Add the ones which aren't 
      #      in the visited list to the back of the queue.
      #   4. Keep repeating steps 2 and 3 until the queue is empty.
      def to_dfa
        dfa_rules = []
        dfa_visited_states = []

        dfa_start_state = to_nfa.current_states
        dfa_discovered_states = [dfa_start_state]

        while dfa_discovered_states.any?
          state = dfa_discovered_states.shift
          dfa_visited_states.push(state)

          rulebook.alphabet.each do |character|
            to_nfa(state).tap do |nfa| 
              nfa.read_character(character) 
              next_state = nfa.current_states
              dfa_rules.push(::FiniteAutomaton::Rule.new(state, character, next_state))

              # Avoid visiting a state that has already been visited or that is about to be visited.
              dfa_discovered_states.push(next_state).uniq! unless dfa_visited_states.include?(next_state) 
            end
          end
        end

        dfa_accept_states = dfa_visited_states.select { |state| to_nfa(state).accepting? }
        ::FiniteAutomaton::DeterministicFiniteAutomaton::Design.new(
          dfa_start_state, 
          dfa_accept_states, 
          ::FiniteAutomaton::DeterministicFiniteAutomaton::RuleBook.new(dfa_rules)
        )
      end
    end
  end
end