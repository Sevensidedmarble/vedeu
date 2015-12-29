# frozen_string_literal: true

module Vedeu

  # This class ensures that STDIN, STDOUT and STDERR point to the
  # correct places. It also handles the initial configuration of the
  # application, the starting of the application, the handling of
  # uncaught exceptions and finally the exiting of the application
  # with the correct exit code.
  #
  class Launcher

    # @!attribute [r] exit_code
    # @return [Fixnum] Return value indicating successful execution
    #   (0) or an error occurred (1).
    attr_reader :exit_code

    # :nocov:
    # @param (see #initialize)
    def self.execute!(argv = [],
                      stdin  = STDIN,
                      stdout = STDOUT,
                      stderr = STDERR,
                      kernel = Kernel)
      new(argv, stdin, stdout, stderr, kernel).execute!
    end
    # :nocov:

    # Returns a new instance of Vedeu::Launcher.
    #
    # @param argv [Array]
    # @param stdin [IO]
    # @param stdout [IO]
    # @param stderr [IO]
    # @param kernel [Kernel]
    # @return [Vedeu::Launcher]
    def initialize(argv   = [],
                   stdin  = STDIN,
                   stdout = STDOUT,
                   stderr = STDERR,
                   kernel = Kernel)
      @argv      = argv
      @stdin     = stdin
      @stdout    = stdout
      @stderr    = stderr
      @kernel    = kernel
      @exit_code = 1
    end

    # Alters the STD[IN|OUT|ERR] to those requested by the client
    # application, then starts the application. If an uncaught
    # exception occurs during the application runtime, we exit
    # ungracefully with any error message(s).
    #
    # If profiling is enabled, execute the application within the
    # profiling context. At the moment, this simple uses 'ruby-prof'
    # to profile the running application.
    #
    # @return [void]
    def execute!
      $stdin  = @stdin
      $stdout = @stdout
      $stderr = @stderr

      optionally_profile { Vedeu::Runtime::Application.start }

      @exit_code = 0

      terminate!

    rescue StandardError => uncaught_exception
      output = if Vedeu.config.debug?
                 uncaught_exception.message + "\n" +
                 uncaught_exception.backtrace.join("\n")
               else
                 uncaught_exception.message
               end

      Vedeu.log(type: :error, message: output)
      Vedeu.log_stdout(type: :error, message: output)
    end

    protected

    # @!attribute [r] argv
    # @return [Array<String>] The command line arguments provided.
    attr_reader :argv

    private

    # @param block [Proc]
    # @return [void]
    def optionally_profile(&block)
      if Vedeu.config.profile?
        Vedeu.profile { yield }

      else
        yield

      end
    end

    # :nocov:
    # Terminates the application after resetting $stdin, $stdout and
    # $stderr.
    #
    # @return [void]
    def terminate!
      Vedeu.log(message: 'Exiting gracefully.')

      $stdin  = STDIN
      $stdout = STDOUT
      $stderr = STDERR

      @kernel.exit(exit_code)
    end
    # :nocov:

  end # Launcher

end # Vedeu
