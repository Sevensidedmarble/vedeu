module Vedeu
  class Application
    class << self
      def start(interfaces = nil, options = {}, &block)
        new(interfaces, options).start(&block)
      end
    end

    def initialize(interfaces = nil, options = {})
      @interfaces, @options = interfaces, options
    end

    def start(&block)
      if block_given?

      else
        Terminal.open(options) do
          Terminal.clear_screen if clear_screen?
          set_cursor

          initial_state

          Clock.start do
            keys = Input::Keyboard.capture

            Commands.execute(keys)

            sleep 0.1
          end
        end
      end
    rescue OutOfTimeError
      # puts 'Done.'
    ensure
      Terminal.show_cursor
    end

    private

    attr_reader :options

    def initial_state
      interfaces.initial
    end

    def interfaces
      @interfaces ||= Interfaces.default
    end

    def clear_screen?
      options.fetch(:clear, true)
    end

    def set_cursor
      cursor_mode.fetch(cursor).call
    end

    def cursor_mode
      {
        show: Proc.new { Terminal.show_cursor },
        hide: Proc.new { Terminal.hide_cursor }
      }
    end

    def cursor
      options.fetch(:cursor, :show)
    end

    def options
      defaults.merge!(@options)
    end

    def defaults
      {
        clear:  true,    # or false (clears the screen if true)
        cursor: :show,   # or :hide
        mode:   :cooked  # or :raw
      }
    end
  end
end
