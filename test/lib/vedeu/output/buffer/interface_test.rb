require_relative '../../../../test_helper'

module Vedeu
  module Buffer
    describe Interface do
      let(:described_class)    { Interface }
      let(:described_instance) { described_class.new(attributes) }
      let(:subject)            { described_instance }
      let(:attributes)         { { name: 'dummy', line: [] } }

      it 'returns a Interface instance' do
        subject.must_be_instance_of(Interface)
      end

      it 'has a name attribute' do
        subject.name.must_be_instance_of(String)
      end

      it 'has a line attribute' do
        subject.line.must_be_instance_of(Array)
      end
    end
  end
end