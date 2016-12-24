require 'pastafari/state'

module Pastafari
  class Fsm
    def self.build(&block)
      raise ArgumentError unless block

      builder = Builders::FsmBuilder.new
      builder.instance_eval(&block)

      builder.build
    end

    def run(input)
      Array(input).map { |value| process(value) }
    end

    attr_reader :states, :transition_at, :current_state

    private

    def initialize(states, transition_at, initial_state)
      @transition_at = transition_at
      @states = states
      @current_state = initial_state || states.first
    end

    def process(input)
      transition!(input) if transition_at == :before

      output = states[current_state].process(input)

      transition!(input) if transition_at == :after

      output
    end

    def transition!(input)
      new_state = states[current_state].evaluate_transitions(input)

      @current_state = new_state if new_state
    end
  end
end
