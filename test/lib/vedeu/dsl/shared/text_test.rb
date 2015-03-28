require 'test_helper'

module Vedeu

  module DSL

    describe Text do

      describe '#text' do
        let(:value)   {}
        let(:options) { {} }
        let(:modified_options) {
          {
            anchor: anchor,
            model:  model,
          }
        }
        let(:anchor)   { :text }
        let(:model)    { Vedeu::Line.new }
        let(:instance) { Vedeu::DSL::Line.new(model) }

        subject { instance.text(value, options) }

        context 'when the model is a Vedeu::Interface' do
          let(:model)    { Vedeu::Interface.new }
          let(:instance) { Vedeu::DSL::Interface.new(model) }

          it { subject.must_be_instance_of(Vedeu::Lines) }

          it 'adds the text to the model' do
            Vedeu::Text.expects(:add).with(value, modified_options)
            subject
          end
        end

        context 'when the model is a Vedeu::Line' do
          let(:model)    { Vedeu::Line.new }
          let(:instance) { Vedeu::DSL::Line.new(model) }

          it { subject.must_be_instance_of(Vedeu::Streams) }

          it 'adds the text to the model' do
            Vedeu::Text.expects(:add).with(value, modified_options)
            subject
          end
        end

        context 'when the model is a Vedeu::Stream' do
          let(:parent)   { Vedeu::Line.new }
          let(:model)    { Vedeu::Stream.new({ parent: parent }) }
          let(:instance) { Vedeu::DSL::Stream.new(model) }

          it { subject.must_be_instance_of(Vedeu::Streams) }

          it 'adds the text to the model' do
            Vedeu::Text.expects(:add).with(value, modified_options)
            subject
          end
        end

        context 'alias methods' do
          context '#align' do
            let(:anchor) { :align }

            it 'adds the text to the model' do
              Vedeu::Text.expects(:add).with(value, modified_options)
              instance.align(value, options)
            end
          end

          context '#center' do
            let(:anchor) { :center }

            it 'adds the text to the model' do
              Vedeu::Text.expects(:add).with(value, modified_options)
              instance.center(value, options)
            end
          end

          context '#centre' do
            let(:anchor) { :centre }

            it 'adds the text to the model' do
              Vedeu::Text.expects(:add).with(value, modified_options)
              instance.centre(value, options)
            end
          end

          context '#left' do
            let(:anchor) { :left }

            it 'adds the text to the model' do
              Vedeu::Text.expects(:add).with(value, modified_options)
              instance.left(value, options)
            end
          end

          context '#right' do
            let(:anchor) { :right }

            it 'adds the text to the model' do
              Vedeu::Text.expects(:add).with(value, modified_options)
              instance.right(value, options)
            end
          end
        end
      end

    end # Text

  end # DSL

end # Vedeu
