require 'spec_helper'

describe Pastafari::Builders::FsmBuilder do
  describe '#state' do
    it 'creates a State and adds it to the list of available states' do
      fsm = Pastafari::Fsm.build do
        state :a_state do
          process { true }
        end
      end

      expect(fsm.states.length).to eq(1)
    end
  end

  describe '#transition' do
    context 'when the value provided is not :before or :after' do
      it 'raises an error' do
        expect do
          Pastafari::Fsm.build do
            transition :symbol
          end
        end.to raise_error(ArgumentError)
      end
    end

    it 'sets transition_at to the given value' do
      fsm = Pastafari::Fsm.build do
        transition :before

        state :a_state do
          process { true }
        end
      end

      expect(fsm.transition_at).to eq(:before)
    end
  end

  describe '#initial_state' do
    it 'sets the initial state to the given value' do
      fsm = Pastafari::Fsm.build do
        initial_state :a_state

        state :a_state do
          process { true }
        end
      end

      expect(fsm.current_state).to eq(:a_state)
    end
  end

  describe '#build' do
    context 'when #initial_state is called with a non-existent state' do
      it 'raises an error' do
        expect do
          Pastafari::Fsm.build do
            initial_state :another_state
            state :a_state do
              process { true }
            end
          end
        end.to raise_error Pastafari::Errors::InvalidStateError
      end
    end

    context 'when a state wants to transition to a non-existent state' do
      it 'raises an error' do
        expect do
          Pastafari::Fsm.build do
            state :a_state do
              process { true }
              transition_to(:another_state).when { true }
            end
          end
        end.to raise_error Pastafari::Errors::InvalidStateError
      end
    end

    context 'when no states are provided' do
      it 'raises an error' do
        expect do
          Pastafari::Fsm.build {}
        end.to raise_error Pastafari::Errors::InvalidStateError
      end
    end

    context 'when a transaction_at is not provided' do
      it 'selects :after' do
        fsm = Pastafari::Fsm.build do
          state :a_state do
            process { true }
          end
        end

        expect(fsm.transition_at).to eq(:after)
      end
    end

    context 'when an initial state is not provided' do
      it 'selects the first state as the initial state' do
        fsm = Pastafari::Fsm.build do
          state :a_state do
            process { true }
          end
        end

        expect(fsm.current_state).to eq(:a_state)
      end
    end

    it 'returns a valid FSM' do
      fsm = Pastafari::Fsm.build do
        state :a_state do
          process { true }
        end
      end

      expect(fsm).to be_a Pastafari::Fsm
    end
  end
end
