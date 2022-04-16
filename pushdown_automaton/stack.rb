# _____________________
# |__|__|__|__|__|__|__
# The top of the stack is the end of the array(contents)
module PushdownAutomaton
  class Stack < Struct.new(:contents)

    def top
      contents.last
    end

    def pop
      contents.pop
    end

    def push(characters)
      contents.push(*characters)
    end

    def inspect
      "#<Stack [Top to Bottom]: (#{top})#{contents[0..-2].reverse.join(',')}>"
    end
  end
end