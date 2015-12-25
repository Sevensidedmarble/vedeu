# frozen_string_literal: true

module Vedeu

  # Provides the mechanism to render views for the client application.
  # The client application's ApplicationView will inherit from this
  # class.
  #
  class ApplicationView

    include Vedeu::View

    # Renders the view.
    #
    # @param (see #initialize)
    # @return [void]
    def self.render(**params)
      new(params).render
    end

    # Returns a new instance of Vedeu::ApplicationView.
    #
    # @param params [Hash]
    # @return [Vedeu::ApplicationView]
    def initialize(**params)
      @params = params

      @params.each do |key, value|
        self.class.send(:define_method, key) { value } unless respond_to?(key)
      end
    end

    # @raise [Vedeu::Error::NotImplemented] Subclasses of this class
    #   must implement this method.
    def render
      fail Vedeu::Error::NotImplemented,
           'The subclass of Vedeu::ApplicationView must implement the #render' \
           'method.'
    end

    protected

    # @!attribute [rw] params
    # @return [Hash]
    attr_accessor :params

    private

    # Provides the path to the template file using the base_path
    # configuration option.
    #
    # @param value [String]
    # @return [String]
    def template(value)
      @template = Vedeu::Configuration.base_path +
                  "/app/views/templates/#{value}.erb"
    end

  end # ApplicationView

end # Vedeu
