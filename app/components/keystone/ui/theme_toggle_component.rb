# frozen_string_literal: true

module Keystone
  module Ui
    class ThemeToggleComponent < ViewComponent::Base
      OPTIONS = [ [ "Light", "light" ], [ "Dark", "dark" ], [ "System", "system" ] ].freeze
      GROUP_CLASSES = "ks-theme-toggle inline-flex gap-1"
      OPTION_CLASSES = "ks-theme-toggle-option ks-button ks-button-sm ks-button-secondary"

      def initialize(current: nil)
        @current = current
      end

      def options
        OPTIONS
      end

      def pressed?(mode)
        mode == KeystoneUi::ThemeChoice.new(@current).mode
      end
    end
  end
end
