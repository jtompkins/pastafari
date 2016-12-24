module Pastafari
  class State
    def self.build(name, &block)
      raise ArgumentError unless block

      builder = Builders::StateBuilder.new(name)
      builder.instance_eval(&block)

      builder.build
    end

    attr_accessor :name, :handler, :transitions

    def process(input)
      handler.call(input)
    end

    def evaluate_transitions(input)
      transition = transitions.detect { |t| t.evaluate(input) }

      transition&.next_state
    end

    private

    def initialize(name, handler, transitions)
      @name = name
      @handler = handler
      @transitions = transitions || []
    end
  end
end
