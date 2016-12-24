require 'spec_helper'

describe Pastafari::Transition do
  let(:state) { :a_state }
  let(:predicate) { -> { true } }

  subject { Pastafari::Transition.new(state) }

  describe '#when' do
    it 'raises an ArgumentError if a block is not provided' do
      expect { subject.when }.to raise_error(ArgumentError)
    end

    it 'sets the predicate' do
      subject.when(&predicate)

      expect(subject.evaluator).to eq(predicate)
    end
  end

  describe '#evaluate' do
    it 'executes the evaluator with the given input' do
      subject.when(&predicate)

      expect(subject.evaluator).to receive(:call).with(true).once

      subject.evaluate(true)
    end
  end
end
