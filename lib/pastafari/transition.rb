module Pastafari
  class Transition
    def initialize(next_state)
      @next_state = next_state
    end

    attr_reader :next_state, :evaluator

    def when(&block)
      raise ArgumentError unless block

      @evaluator = block
    end

    def evaluate(input)
      raise Pastafari::Errors::InvalidStateError unless evaluator

      evaluator.call(input)
    end
  end
end
