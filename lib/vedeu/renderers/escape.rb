# frozen_string_literal: true

module Vedeu

  module Renderers

    # Converts a grid of {Vedeu::Cells} objects or
    # {Vedeu::Cells::Char} objects into a stream of characters without
    # escape sequences.
    #
    class Escape < Vedeu::Renderers::File

      include Vedeu::Renderers::Options

      # Render a cleared output.
      #
      # @return [String]
      def clear
        render('[[:clear]]')
      end

      private

      # Combine all characters in a row to produce a line, then all
      # lines should be terminated with `\n`. Convert to an array of
      # UTF8 codepoints, and any codepoint above 255 should be
      # converted to a space.
      #
      # @return [String]
      def content
        return '[[:empty]]' if string?(output) || absent?(output)

        buffer.map { |row| row.join("\n") }.join("\n\n")
      end

      # @return [Array<String>]
      def buffer
        empty = Array.new(Vedeu.height) { Array.new(Vedeu.width) { '[:cell]' } }

        output.each do |row|
          row.each do |char|
            next unless renderable?(char) &&
                        positionable?(char) &&
                        escapable?(char)

            empty[char.position.y - 1][char.position.x - 1] = char.to_ast
          end
        end

        empty
      end

      # @return [Boolean]
      def positionable?(char)
        char.respond_to?(:position) &&
        char.position.is_a?(Vedeu::Geometries::Position)
      end

      # @return [Array<Class>]
      def renderables
        [
          Vedeu::Cells::Border,
          Vedeu::Cells::BottomHorizontal,
          Vedeu::Cells::BottomLeft,
          Vedeu::Cells::BottomRight,
          Vedeu::Cells::Corner,
          Vedeu::Cells::Char,
          Vedeu::Cells::Clear,
          Vedeu::Cells::Cursor,
          Vedeu::Cells::Empty,
          Vedeu::Cells::Escape,
          Vedeu::Cells::Horizontal,
          Vedeu::Cells::LeftVertical,
          Vedeu::Cells::RightVertical,
          Vedeu::Cells::TopHorizontal,
          Vedeu::Cells::TopLeft,
          Vedeu::Cells::TopRight,
          Vedeu::Cells::Vertical,
        ]
      end

      # @return [Boolean]
      def renderable?(char)
        renderables.include?(char.class)
      end

      # @return [Boolean]
      def escapable?(char)
        char.respond_to?(:to_ast)
      end

    end # Escape

  end # Renderers

end # Vedeu
