module Vedeu

  # Allows the storing of interface/view geometry independent of the interface
  # instance.
  class Geometries < Repository

    class << self

      # @return [Vedeu::Geometries]
      def geometries
        @geometries ||= reset!
      end
      alias_method :repository, :geometries

      # Remove all stored models from the repository.
      #
      # @return [Vedeu::Geometries]
      def reset!
        @geometries = Vedeu::Geometries.register(Vedeu::Geometry)
      end

    end

    null Vedeu::Null::Geometry

  end # Geometries

end # Vedeu