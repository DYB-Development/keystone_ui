# frozen_string_literal: true

module Keystone
  module Ui
    class TabSwitcherComponent < ViewComponent::Base
      TAB_BAR_CLASSES = "ks-tab-bar flex flex-wrap justify-center max-sm:flex-nowrap max-sm:overflow-x-auto max-sm:justify-start"
      TAB_BASE_CLASSES = "ks-tab text-sm transition max-sm:shrink-0 max-sm:whitespace-nowrap"
      PANEL_CLASSES = "hidden"
      LAYOUT_CLASSES = "max-sm:flex max-sm:flex-col"
      SUMMARY_CLASSES = "max-sm:order-1 max-sm:[&>:first-child]:mt-0 max-sm:[&>:last-child]:mb-0"
      CONTENT_CLASSES = "max-sm:order-1"

      renders_one :summary

      attr_reader :tabs

      def initialize(tabs:)
        @tabs = tabs
      end

      def link_tabs?
        tabs.any? && tabs.all?(Hash)
      end

      def classes
        TAB_BAR_CLASSES
      end

      def tab_classes
        "#{TAB_BASE_CLASSES} ks-tab-active"
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
