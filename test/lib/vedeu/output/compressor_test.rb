require 'test_helper'

module Vedeu

  describe Compressor do

    let(:described) { Vedeu::Compressor }
    let(:instance)  { described.new(output) }
    let(:output)    {}

    describe '#initialize' do
      it { instance.must_be_instance_of(described) }
      it { instance.instance_variable_get('@output').must_equal(output) }
      it { instance.instance_variable_get('@colour').must_equal('') }
      it { instance.instance_variable_get('@style').must_equal('') }
    end

    describe '.render' do
      it { described.must_respond_to(:render) }
    end

    describe '#render' do
      subject { instance.render }

      it { subject.must_be_instance_of(String) }

      context 'when compression is enabled' do
        before { Vedeu.configure { compression(true) } }

        context 'when the output is all Vedeu::Char elements' do
          let(:output) {
            [
              Vedeu::Char.new(value: 'Y', colour: { foreground: '#ff0000' }),
              Vedeu::Char.new(value: 'e', colour: { foreground: '#ff0000' }),
              Vedeu::Char.new(value: 's', colour: { foreground: '#ff0000' }),
            ]
          }
          it 'converts the non-Vedeu::Char elements into String elements' do
            subject.must_equal("\e[38;2;255;0;0mYes")
          end
        end

        context 'when the output is all Vedeu::Char elements' do
          let(:output) {
            [
              Vedeu::Char.new(value: 'a', colour: { foreground: '#ff0000' }),
              Vedeu::Char.new(value: 'b', colour: { foreground: '#ff0000' }),
              Vedeu::Char.new(value: 'c', colour: { foreground: '#0000ff' }),
              Vedeu::Char.new(value: 'd', colour: { foreground: '#0000ff' }),
            ]
          }
          it 'compresses multiple colours and styles where possible' do
            subject.must_equal("\e[38;2;255;0;0mab\e[38;2;0;0;255mcd")
          end
        end

        context 'when the output is not all Vedeu::Char elements' do
          let(:output) {
            [
              Vedeu::Char.new(value: 'N'),
              Vedeu::Escape.new("\e[?25l"),
              Vedeu::Char.new(value: 't'),
            ]
          }
          it 'converts the non-Vedeu::Char elements into String elements' do
            subject.must_equal("N\e[?25lt")
          end
        end
      end

      context 'when compression is not enabled' do
        before { Vedeu.configure { compression(false) } }

        context 'when the output is all Vedeu::Char elements' do
          let(:output) {
            [
              Vedeu::Char.new(value: 'Y', colour: { foreground: '#ff0000' }),
              Vedeu::Char.new(value: 'e', colour: { foreground: '#ff0000' }),
              Vedeu::Char.new(value: 's', colour: { foreground: '#ff0000' }),
            ]
          }
          it 'converts the non-Vedeu::Char elements into String elements' do
            subject.must_equal(
              "\e[38;2;255;0;0mY\e[38;2;255;0;0me\e[38;2;255;0;0ms"
            )
          end
        end

        context 'when the output is all Vedeu::Char elements' do
          let(:output) {
            [
              Vedeu::Char.new(value: 'a', colour: { foreground: '#ff0000' }),
              Vedeu::Char.new(value: 'b', colour: { foreground: '#ff0000' }),
              Vedeu::Char.new(value: 'c', colour: { foreground: '#0000ff' }),
              Vedeu::Char.new(value: 'd', colour: { foreground: '#0000ff' }),
            ]
          }
          it 'compresses multiple colours and styles where possible' do
            subject.must_equal(
              "\e[38;2;255;0;0ma\e[38;2;255;0;0mb\e[38;2;0;0;255mc\e[38;2;0;0;255md"
            )
          end
        end

        context 'when the output is not all Vedeu::Char elements' do
          let(:output) {
            [
              Vedeu::Char.new(value: 'N'),
              Vedeu::Escape.new("\e[?25l"),
              Vedeu::Char.new(value: 't'),
            ]
          }
          it 'converts the non-Vedeu::Char elements into String elements' do
            subject.must_equal("N\e[?25lt")
          end
        end
      end
    end

  end # Compressor

end # Vedeu
