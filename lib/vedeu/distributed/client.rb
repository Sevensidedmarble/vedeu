module Vedeu

  module Distributed

    # A class for the client side of the DRb server/client relationship.
    #
    # @example
    #   client = Vedeu::Distributed::Client.connect("druby://localhost:21420")
    #   client.input('a')
    #   client.output # => 'some content...'
    #
    class Client

      # @param (see #initialize)
      def self.connect(uri)
        new(uri).connect
      end

      # Returns a new instance of Vedeu::Distributed::Client.
      #
      # @param uri [Vedeu::Distributed::Uri|String]
      # @return [Client]
      def initialize(uri)
        @uri = uri.to_s
      end

      # Simulate connecting to the DRb server by requesting its status.
      #
      # @return [Symbol]
      def connect
        server.status

      rescue DRb::DRbConnError
        drb_connection_error

      rescue DRb::DRbBadURI
        puts 'Could not connect to DRb server, URI may be bad.'

        :drb_bad_uri

      end

      # Send input to the DRb server.
      #
      # @param data [String|Symbol]
      # @return [void|Symbol]
      def input(data)
        server.input(data)

      rescue DRb::DRbConnError
        drb_connection_error

      end
      alias_method :read, :input

      # Fetch output from the DRb server.
      #
      # @return [void|Symbol]
      def output
        server.output

      rescue DRb::DRbConnError
        drb_connection_error

      end
      alias_method :write, :output

      # Shutdown the DRb server and the client application.
      #
      # @note
      #   {Vedeu::Application} will raise StopIteration when its `.stop` method
      #   is called. Here we rescue that to give a clean client exit.
      #
      # @return [void|Symbol]
      def shutdown
        server.shutdown

        Process.kill("KILL", server.pid)

      rescue DRb::DRbConnError
        drb_connection_error

      rescue Interrupt
        puts 'Client application exited.'

      ensure
        :shutdown

      end

      private

      # @!attribute [r] uri
      # @return [String]
      attr_reader :uri

      # @return [void]
      def server
        @server ||= DRbObject.new_with_uri(uri)
      end

      # @return [Symbol]
      def drb_connection_error
        puts 'Could not connect to DRb server.'

        :drb_connection_error
      end

    end # Client

  end # Distributed

end # Vedeu
