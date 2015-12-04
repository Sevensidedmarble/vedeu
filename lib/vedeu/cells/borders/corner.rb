module Vedeu

  module Cells

    # Provides the position information to draw a border corner.
    #
    # @api private
    #
    class Corner < Vedeu::Cells::Border

      # @return [Vedeu::Geometries::Position]
      def position
        @position = defaults[:position]
      end

      # @return [String]
      def text
        '+'
      end

    end # Corner

  end # Cells

end # Vedeu
