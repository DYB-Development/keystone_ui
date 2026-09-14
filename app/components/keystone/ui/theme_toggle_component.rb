# frozen_string_literal: true

module Keystone
  module Ui
    class ThemeToggleComponent < ViewComponent::Base
      OPTIONS = [ [ "Light", "light" ], [ "Dark", "dark" ], [ "System", "system" ] ].freeze

      def initialize(current: nil)
        @current = current
      end

      def options
        OPTIONS
      end

      def pressed?(mode)
        mode == (KeystoneUi::ThemeChoice::MODES.include?(@current) ? @current : "system")
      end
    end
  end
end
