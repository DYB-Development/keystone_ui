# frozen_string_literal: true

module Keystone
  module Ui
    class TabSwitcherComponent < ViewComponent::Base
      TAB_BAR_CLASSES = "mb-8 flex flex-wrap justify-center gap-2"
      TAB_BASE_CLASSES = "rounded-lg px-4 py-2 text-sm font-semibold transition text-gray-500 hover:text-gray-900 dark:text-gray-400 dark:hover:text-white"
      PANEL_CLASSES = "hidden"

      attr_reader :tabs

      def initialize(tabs:)
        @tabs = tabs
      end

      def classes
        TAB_BAR_CLASSES
      end

      def tab_classes
        "#{TAB_BASE_CLASSES} data-[active]:bg-accent-500/10 data-[active]:text-accent-600 dark:data-[active]:bg-accent-500/10 dark:data-[active]:text-accent-400"
      end

      def panel_classes
        PANEL_CLASSES
      end
    end
  end
end
