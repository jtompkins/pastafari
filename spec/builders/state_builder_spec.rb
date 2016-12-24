require 'spec_helper'

describe Pastafari::Builders::StateBuilder do
  let(:first_state) { :a_state }

  describe '#process' do
    it 'sets the handler properly on the State instance' do
      handler = -> { true }
      state = Pastafari::State.build(first_state) do
        process(&handler)
      end

      expect(state.handler).to eq(handler)
    end
  end

  describe '#transition_to' do
    it 'creates a Transition and adds it to the list of transitions' do
      state = Pastafari::State.build(first_state) do
        process { true }
        transition_to(:another_state).when { true }
      end

      expect(state.transitions.length).to eq(1)
    end
  end

  describe '#build' do
    it 'raises an error if #process has not been called' do
      expect do
        Pastafari::State.build(first_state) do
          transition_to(:another_state).when { true }
        end
      end.to raise_error(Pastafari::Errors::InvalidStateError)
    end

    it 'produces a valid State instance' do
      state = Pastafari::State.build(first_state) do
        process { true }
      end

      expect(state).to be_a(Pastafari::State)
    end
  end
end
