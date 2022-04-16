module PushdownAutomaton 
  class NonDeterministicPushdownAutomaton 
    module Strategies
      class BaseStrategy
        attr_accessor :rulebook,
                      :current_configurations

        def read_string(current_configurations, rulebook, string)
          raise 'Must implement read_string!'
        end
      end
    end
  end
end
