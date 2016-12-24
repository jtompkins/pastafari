module Pastafari
  module Builders
    class FsmBuilder
      VALID_TRANSITIONS = [:before, :after].freeze

      def initialize
        @states = {}
        @transition_at = :after
      end

      def state(name, &block)
        builder = Builders::StateBuilder.new(name)
        builder.instance_eval(&block)

        state = builder.build

        @states[state.name] = state
      end

      def transition(at)
        validate_transition_at(at)

        @transition_at = at
      end

      def initial_state(state)
        @initial_state = state
      end

      def build
        validate_states_given
        validate_initial_state
        validate_transitions

        set_initial_state!

        Pastafari::Fsm.new(@states, @transition_at, @initial_state)
      end

      private

      def set_initial_state!
        @initial_state ||= @states.values.first.name
      end

      def validate_transition_at(at)
        return if VALID_TRANSITIONS.include?(at)

        raise ArgumentError, 'Transition value must be one of :before, :after.'
      end

      def validate_states_given
        return unless @states.length.zero?

        raise Pastafari::Errors::InvalidStateError, 'No states defined.'
      end

      def validate_initial_state
        return unless @initial_state

        return if @states.key?(@initial_state)

        raise Pastafari::Errors::InvalidStateError,
              'Initial state points to a non-existent state.'
      end

      def validate_transitions
        @states.each do |name, state|
          state.transitions.map(&:next_state).each do |k|
            next if @states.key? k

            raise Pastafari::Errors::InvalidStateError,
                  "State #{name} is transitioning to non-existent state #{k}"
          end
        end
      end
    end
  end
end
