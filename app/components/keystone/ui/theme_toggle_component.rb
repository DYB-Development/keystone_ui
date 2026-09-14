# frozen_string_literal: true

module Keystone
  module Ui
    class ThemeToggleComponent < ViewComponent::Base
      OPTIONS = [ [ "Light", "light" ], [ "Dark", "dark" ], [ "System", "system" ] ].freeze
      GROUP_CLASSES = "inline-flex gap-1"
      OPTION_CLASSES = "ks-button ks-button-sm ks-button-secondary aria-pressed:bg-accent-600 aria-pressed:hover:bg-accent-500"

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
