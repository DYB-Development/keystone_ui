# frozen_string_literal: true

module Keystone
  module Ui
    class TabSwitcherComponent < ViewComponent::Base
      TAB_BAR_CLASSES = "ks-tab-bar flex flex-wrap justify-center"
      TAB_BASE_CLASSES = "ks-tab text-sm transition"
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

      def wrapper_data
        { controller: "tab-switcher" }
      end
    end
  end
end
