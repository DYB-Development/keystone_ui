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
        accent = KeystoneUi::AccentColors.current
        active_bg = accent[:bg].split.map { |c| "data-[active]:#{c}" }.join(" ")
        active_text = accent[:text].split.map { |c| "data-[active]:#{c}" }.join(" ")
        dark_active_bg = accent[:bg].split.map { |c| "dark:data-[active]:#{c}" }.join(" ")
        dark_active_text = accent[:dark_text].gsub("dark:", "").split.map { |c| "dark:data-[active]:#{c}" }.join(" ")
        "#{TAB_BASE_CLASSES} #{active_bg} #{active_text} #{dark_active_bg} #{dark_active_text}"
      end

      def panel_classes
        PANEL_CLASSES
      end
    end
  end
end
