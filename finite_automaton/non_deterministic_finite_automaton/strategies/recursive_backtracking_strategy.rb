module FiniteAutomaton
  class NonDeterministicFiniteAutomaton
    module Strategies
      class RecursiveBacktrackingStrategy < BaseStrategy      
        def read_string(current_states, rulebook, string)
          @current_states = current_states
          @rulebook = rulebook

          @current_states = 
            current_states.reduce([]) do |acc, current_state| 
              acc.concat(read_substring(current_state, string))
            end
        end
  
        private
          # Recursion:
          #   • Base Case(s): 
          #       1. Criteria: If the substring is empty i.e we have finished reading the input AND 
          #                    there are no more applicable nil transitions. 
          #          Action: Return the current_state. This will be bubbled up and 
          #                  cumulatively checked to see if any is an accepting state.
          #       2 Criteria: If there are no applicable rules (both character and nil transitions) despite
          #                   there being characters in the substring. 
          #         Action: In this case we return empty which indicates the current_state cannot 
          #                  qualify for accepting_states because we haven't consumed all the input.
          #   • Iteration Step:
          #       • If applicable rules exist; then follow each rule sequentially by:
          #           a) Retrieving the unread part of the substring i.e substring.chars[1..-1] . If nil transition, nothing is read
          #           b) Recursively calling read_substring with the rule's next state and the unread part of substring 
          def read_substring(current_state, substring)
            states = []

            rules = []
            rules.concat(rulebook.rules_for(current_state, nil))
            rules.concat(rulebook.rules_for(current_state, substring.chars.first)) unless substring.empty?
            
  
            rules.each do |rule|
              unread_substring = rule.character.nil? ? substring : substring[1..-1] 
              states.concat(read_substring(rule.next_state, unread_substring))
            end

            states.push(current_state) if rules.empty? && substring.empty?
            states
          end
      end
    end
  end
end