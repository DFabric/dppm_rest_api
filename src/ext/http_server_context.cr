require "kemal"

class HTTP::Server
  class Context
    macro finished
      @stacks = {} of String => Deque(StoreTypes)
    end

    def push(key : String, value : StoreTypes) : Deque(StoreTypes)
      stack = @stacks[key]? || Deque(StoreTypes).new
      stack.push value
      @stacks[key] = stack
    end

    def pop?(key : String)
      @stacks[key]?.try &.pop?
    end

    def pop(key : String)
      pop?(key) || raise KeyError.new "context has no items for #{key}"
    end
  end
end
