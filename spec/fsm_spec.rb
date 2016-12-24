require 'spec_helper'

describe Pastafari::Fsm do
  describe '#build' do
    it 'raises an error if a block is not provided' do
      expect { Pastafari::Fsm.build }.to raise_error(ArgumentError)
    end
  end

  describe '#run' do
    context 'when #transition_at is set to :before' do
      it 'calls the transition function before the handler' do
        first_handler = -> { true }
        second_handler = -> { true }
        first_transition = ->(i) { i }

        fsm = Pastafari::Fsm.build do
          transition :before

          state :first_state do
            process(&first_handler)

            transition_to(:second_state).when(&first_transition)
          end

          state :second_state do
            process(&second_handler)
          end
        end

        allow(first_transition).to receive(:call).and_return(true)

        expect(first_transition).to receive(:call).with(true)
        expect(second_handler).to receive(:call).with(true)

        fsm.run(true)
      end
    end

    context 'when #transition_at is set to :after' do
      it 'calls the transition function after the handler' do
        first_handler = -> { true }
        second_handler = -> { true }
        first_transition = ->(i) { i }

        fsm = Pastafari::Fsm.build do
          transition :after

          state :first_state do
            process(&first_handler)

            transition_to(:second_state).when(&first_transition)
          end

          state :second_state do
            process(&second_handler)
          end
        end

        allow(first_transition).to receive(:call).and_return(true)

        expect(first_handler).to receive(:call).with(true)
        expect(first_transition).to receive(:call).with(true)
        expect(second_handler).to receive(:call).with(true)

        fsm.run([true, true])
      end
    end

    it 'transitions between states when the transition predicate is truthy' do
      first_handler = -> { 1 }
      second_handler = -> { 2 }

      fsm = Pastafari::Fsm.build do
        transition :after

        state :first_state do
          process(&first_handler)

          transition_to(:second_state).when { |i| i }
        end

        state :second_state do
          process(&second_handler)
        end
      end

      allow(first_handler).to receive(:call).and_return(1)
      allow(second_handler).to receive(:call).and_return(2)

      expect(first_handler).to receive(:call).with(true)
      expect(second_handler).to receive(:call).with(false)

      output = fsm.run([true, false])

      expect(output).to eq([1, 2])
    end

    it 'returns output as an Array' do
      fsm = Pastafari::Fsm.build do
        state :first_state do
          process { 1 }
        end
      end

      output = fsm.run([true, true])

      expect(output).to be_an(Array)
    end

    it 'returns the output from each state handler' do
      fsm = Pastafari::Fsm.build do
        transition :after

        state :first_state do
          process { 1 }
        end
      end

      output = fsm.run([true, false])

      expect(output).to eq([1, 1])
    end
  end
end
