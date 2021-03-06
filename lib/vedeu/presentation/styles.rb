# frozen_string_literal: true

module Vedeu

  module Presentation

    # Provides style related presentation behaviour.
    #
    # @api private
    #
    module Styles

      include Vedeu::Common
      include Vedeu::Presentation::Parent

      # When the style for the model exists, return it, otherwise
      # returns the parent style, or an empty
      # {Vedeu::Presentation::Style}.
      #
      # @return [Vedeu::Presentation::Style]
      def style
        @_style ||= if style?
                      Vedeu::Presentation::Style.coerce(@style)

                    elsif parent? && present?(parent.style)
                      Vedeu::Presentation::Style.coerce(parent.style)

                    else
                      Vedeu::Presentation::Style.new

                    end
      end

      # Allows the setting of the style by coercing the given value
      # into a {Vedeu::Presentation::Style}.
      #
      # @return [Vedeu::Presentation::Style]
      def style=(value)
        @_style = @style = Vedeu::Presentation::Style.coerce(value)
      end

      # @return [Boolean]
      def style?
        present?(@style)
      end

      private

      # Renders the style attributes of the receiver and yields (to
      # then render the next model, or finally, the content).
      #
      # @macro param_block
      # @return [String]
      def render_style(&block)
        "#{style}#{yield}"
      end

    end # Style

  end # Presentation

end # Vedeu
