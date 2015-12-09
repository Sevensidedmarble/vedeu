module Vedeu

  # This module is the direct interface between Vedeu and your
  # terminal/ console, via Ruby's IO core library.
  #
  module Terminal

    include Vedeu::Terminal::Mode
    extend self

    # Opens a terminal screen in either `raw` or `cooked` mode. On
    # exit, attempts to restore the screen. See
    # {Vedeu::Terminal#restore_screen}.
    #
    # @param block [Proc]
    # @raise [Vedeu::Error::RequiresBlock] The required block was not
    #   given.
    # @return [Array]
    def open(&block)
      fail Vedeu::Error::RequiresBlock unless block_given?

      if raw_mode? || fake_mode?
        console.raw    { initialize_screen(mode) { yield } }

      else
        console.cooked { initialize_screen(mode) { yield } }

      end
    ensure
      restore_screen
    end

    # Prints the streams to the screen and returns the streams.
    #
    # @param streams [String|Array]
    # @return [Array]
    def output(*streams)
      streams.each do |stream|
        Vedeu.log(type:    :output,
                  message: "Writing to terminal #{stream.size} bytes".freeze)

        console.print(stream)
      end
    end
    alias_method :write, :output

    # {include:file:docs/dsl/by_method/resize.md}
    # @return [Boolean]
    def resize
      Vedeu.trigger(:_clear_)

      Vedeu.trigger(:_refresh_)

      true
    end

    # @param block [Proc]
    # @param mode [Symbol]
    # @return [void]
    def initialize_screen(mode, &block)
      Vedeu.log(message: "Terminal entering '#{mode}' mode".freeze)

      output(Vedeu::EscapeSequences::Esc.screen_init)

      yield if block_given?
    end

    # Disables the mouse and shows the cursor. Used by the debugging
    # snippet in {file:docs/debugging.md}.
    #
    # @return [String]
    def debugging!
      output(Vedeu::EscapeSequences::Esc.mouse_x10_off +
             Vedeu::EscapeSequences::Esc.show_cursor)
    end

    # Clears the entire terminal space.
    #
    # @example
    #   Vedeu.clear
    #
    # @return [String]
    def clear
      output(Vedeu::EscapeSequences::Esc.clear)
    end

    # Attempts to tidy up the screen just before the application
    # terminates. The cursor is shown, colours are reset to terminal
    # defaults, the terminal is told to reset, and finally we clear
    # the last line ready for the prompt.
    #
    # @return [String]
    def restore_screen
      output(Vedeu::EscapeSequences::Esc.screen_exit)
    end

    # Sets the cursor to be visible unless in raw mode, whereby it
    # will be left hidden.
    #
    # @return [String]
    def set_cursor_mode
      output(Vedeu::EscapeSequences::Esc.show_cursor) unless raw_mode?
    end

    # Returns a coordinate tuple of the format [y, x], where `y` is
    # the row/line and `x` is the column/character.
    #
    # @return [Array]
    def centre
      [(height / 2), (width / 2)]
    end

    # Returns the `y` (row/line) component of the coordinate tuple
    # provided by {Vedeu::Terminal.centre}
    #
    # @return [Fixnum]
    def centre_y
      centre[0]
    end

    # Returns the `x` (column/character) component of the coodinate
    # tuple provided by {Vedeu::Terminal.centre}
    #
    # @return [Fixnum]
    def centre_x
      centre[-1]
    end

    # Returns 1. This 1 is either the top-most or left-most coordinate
    # of the terminal.
    #
    # @return [Fixnum]
    def origin
      1
    end
    alias_method :x, :origin
    alias_method :y, :origin
    alias_method :tx, :origin
    alias_method :ty, :origin

    # {include:file:docs/dsl/by_method/width.md}
    # @return [Fixnum]
    def width
      return Vedeu::Configuration.drb_width if Vedeu::Configuration.drb?
      return Vedeu::Configuration.width     if Vedeu::Configuration.width

      size[-1]
    end
    alias_method :xn, :width
    alias_method :txn, :width

    # {include:file:docs/dsl/by_method/height.md}
    # @return [Fixnum]
    def height
      return Vedeu::Configuration.drb_height if Vedeu::Configuration.drb?
      return Vedeu::Configuration.height     if Vedeu::Configuration.height

      size[0]
    end
    alias_method :yn, :height
    alias_method :tyn, :height

    # Returns a tuple containing the height and width of the current
    # terminal.
    #
    # @note
    #   If the terminal is a odd number of characters in height or
    #   width, then 1 is deducted from the dimension to make it even.
    #   For example; the actual terminal is height: 37, width: 145,
    #   then the reported size will be 36, 144 respectively.
    #
    #   This is done to make it easier for client applications to
    #   divide the terminal space up when defining interfaces or
    #   views, leading to more consistent rendering.
    #
    #   If the client application is using the
    #   {Vedeu::Geometries::Grid#rows} or
    #   {Vedeu::Geometries::Grid#columns} helpers, the dimensions are
    #   made more consistent using this approach.
    #
    # @return [Array]
    def size
      h, w = console.winsize

      h = (h.even? ? h : h - 1)
      w = (w.even? ? w : w - 1)

      [h, w]
    end

    # Provides our gateway into the wonderful rainbow-filled world of
    # IO.
    #
    # @return [File]
    def console
      IO.console
    end

  end # Terminal

  # @!method height
  #   @see Vedeu::Terminal#height
  # @!method resize
  #   @see Vedeu::Terminal#resize
  # @!method width
  #   @see Vedeu::Terminal#width
  def_delegators Vedeu::Terminal,
                 :height,
                 :resize,
                 :width

  # :nocov:

  # See {file:docs/events/view.md#\_resize_}
  Vedeu.bind(:_resize_, delay: 0.25) { Vedeu.resize }

  # :nocov:

end # Vedeu
