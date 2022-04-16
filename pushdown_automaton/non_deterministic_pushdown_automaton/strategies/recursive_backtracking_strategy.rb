module PushdownAutomaton 
  class NonDeterministicPushdownAutomaton 
    module Strategies
      class RecursiveBacktrackingStrategy < BaseStrategy
        def read_string(current_configurations, rulebook, string)
          @current_configurations = current_configurations
          @rulebook = rulebook

          @current_configurations = 
            current_configurations.reduce([]) do |acc, current_configuration| 
              acc.concat(read_substring(current_configuration, string))
            end
        end

        private
          # Recursion:
          #   • Base Case(s): 
          #       1. Criteria: If the substring is empty i.e we have finished reading the input AND 
          #                    there are no more applicable nil transitions. 
          #          Action: Return the current_configuration. This will be bubbled up and 
          #                  cumulatively checked to see if any is an accepting configuration.
          #       2. Criteria: If there are no applicable rules (both character and nil transitions) despite
          #                    there being characters in the substring. 
          #          Action: In this case we return empty which indicates the current_configuration cannot 
          #                  qualify for accepting_configurations because we haven't consumed all the input.
          #   • Iteration Step:
          #       • If applicable rules exist; then follow each rule sequentially by:
          #           a) Retrieving the unread part of the substring i.e substring.chars[1..-1] . If nil transition, nothing is read
          #           b) Recursively calling read_substring with the rule's next configuration and the unread part of substring 
          def read_substring(current_configuration, substring)
            configurations = []

            rules = []
            rules.concat(rulebook.rules_for(current_configuration, nil))
            rules.concat(rulebook.rules_for(current_configuration, substring.chars.first)) unless substring.empty?
            
  
            rules.each do |rule|
              unread_substring = rule.character.nil? ? substring : substring[1..-1] 
              configurations.concat(read_substring(rule.follow(current_configuration), unread_substring))
            end

            configurations.push(current_configuration) if rules.empty? && substring.empty?
            configurations
          end  
      end
    end
  end
end
