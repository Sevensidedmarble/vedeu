# frozen_string_literal: true

module Vedeu

  module Groups

    # Refresh an interface, or collection of interfaces belonging to a
    # group.
    #
    # The interfaces will be refreshed in z-index order, meaning that
    # interfaces with a lower z-index will be drawn first. This means
    # overlapping interfaces will be drawn as specified.
    #
    # @example
    #   Vedeu.trigger(:_refresh_group_, group_name)
    #
    class Refresh

      include Vedeu::Common

      # @macro param_name
      # @return [Array|Vedeu::Error::ModelNotFound] A collection of
      #   the names of interfaces refreshed, or an exception when the
      #   group was not found.
      def self.by_name(name)
        new(name).by_name
      end

      # Return a new instance of Vedeu::Groups::Refresh.
      #
      # @macro param_name
      # @return [Vedeu::Groups::Refresh]
      def initialize(name)
        @name = name
      end

      # @return [void]
      def by_name
        Vedeu.timer("Refresh Group: '#{group_name}'") do
          Vedeu.groups.by_name(group_name).by_zindex.each do |name|
            Vedeu.trigger(:_refresh_view_, name)
          end
        end
      end

      protected

      # @!attribute [r] name
      # @macro return_name
      attr_reader :name

      private

      # @macro raise_missing_required
      # @return [String]
      def group_name
        return name if present?(name)
        return group_from_interface if present?(group_from_interface)

        raise Vedeu::Error::MissingRequired,
              'Cannot refresh group with an empty group name.'
      end

      # @return [String|Symbol]
      def group_from_interface
        @_group_name ||= interface.group
      end

      # @return [Vedeu::Interfaces::Interface]
      def interface
        Vedeu.interfaces.by_name(name)
      end

    end # Refresh

  end # Groups

  # :nocov:

  # See {file:docs/events/refresh.md}
  Vedeu.bind(:_refresh_group_) do |name|
    Vedeu::Groups::Refresh.by_name(name) if Vedeu.ready?
  end

  # :nocov:

end # Vedeu
