module Pastafari
  module Builders
    class StateBuilder
      def initialize(name)
        @name = name
        @transitions = []
      end

      def process(&block)
        raise ArgumentError unless block

        @handler = block
      end

      def transition_to(new_state)
        Pastafari::Transition.new(new_state).tap { |t| @transitions << t }
      end

      def build
        validate_handler

        State.new(@name, @handler, @transitions)
      end

      private

      def validate_handler
        return if @handler

        raise Pastafari::Errors::InvalidStateError,
              '#process must be called when defining the State.'
      end
    end
  end
end
