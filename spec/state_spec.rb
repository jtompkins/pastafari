require 'spec_helper'

describe Pastafari::State do
  describe '#build' do
    it 'raises an error if a block is not provided' do
      expect { Pastafari::State.build }.to raise_error(ArgumentError)
    end
  end

  describe '#process' do
    it 'calls the handler with the given input' do
      handler = -> { true }

      state = Pastafari::State.build :a_state do
        process(&handler)
      end

      expect(handler).to receive(:call).with(true)

      state.process(true)
    end
  end

  describe '#evaluate_transitions' do
    it 'calls the transition func for each transition' do
      func = -> { false }

      state = Pastafari::State.build :a_state do
        process { true }

        transition_to(:another_state).when(&func)
        transition_to(:one_more_state).when(&func)
      end

      expect(func).to receive(:call).at_least(:once)

      state.evaluate_transitions(true)
    end

    it 'returns the state for which the func returns truthy' do
      state = Pastafari::State.build :a_state do
        process { true }

        transition_to(:another_state).when { false }
        transition_to(:one_more_state).when { true }
      end

      expect(state.evaluate_transitions(true)).to eq(:one_more_state)
    end

    it 'returns nil if no func returns truthy' do
      state = Pastafari::State.build :a_state do
        process { true }

        transition_to(:another_state).when { false }
        transition_to(:one_more_state).when { false }
      end

      expect(state.evaluate_transitions(true)).to be_nil
    end
  end
end
