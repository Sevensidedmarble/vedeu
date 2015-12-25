# frozen_string_literal: true

module Vedeu

  module EscapeSequences

    # Provides border/box related escape sequences for semigraphic
    # characters.
    #
    # # 0 1 2 3 4 5 6 7 8 9 A B C D E F
    # 6                     ┘ ┐ ┌ └ ┼
    # 7   ─     ├ ┤ ┴ ┬ │
    #
    # @note
    #   Refer to UTF-8 U+2500 to U+257F for border characters. More
    #   details can be found at:
    #
    #   http://en.wikipedia.org/wiki/Box-drawing_character
    #
    #   Using the '\uXXXX' variant produces gaps in the border, whilst
    #   the '\xXX' renders 'nicely'.
    #
    module Borders

      extend self

      # @return [String]
      def border_off
        "\e(B"
      end

      # @return [String]
      def border_on
        "\e(0"
      end

      # └ # \u2514
      #
      # @return [String]
      def bottom_left
        "\x6D"
      end

      # ┘ # \u2518
      #
      # @return [String]
      def bottom_right
        "\x6A"
      end

      # ─ # \u2500
      #
      # @return [String]
      def horizontal
        "\x71"
      end

      # ┴ # \u2534
      #
      # @return [String]
      def horizontal_bottom
        "\x76"
      end

      # ┬ # \u252C
      #
      # @return [String]
      def horizontal_top
        "\x77"
      end

      # ┌ # \u250C
      #
      # @return [String]
      def top_left
        "\x6C"
      end

      # ┐ # \u2510
      #
      # @return [String]
      def top_right
        "\x6B"
      end

      # │ # \u2502
      #
      # @return [String]
      def vertical
        "\x78"
      end

      # ├ # \u251C
      #
      # @return [String]
      def vertical_left
        "\x74"
      end

      # ┤ # \u2524
      #
      # @return [String]
      def vertical_right
        "\x75"
      end

    end # Borders

  end # EscapeSequences

end # Vedeu
