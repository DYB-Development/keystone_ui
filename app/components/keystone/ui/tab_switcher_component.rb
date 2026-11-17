# frozen_string_literal: true

module Keystone
  module Ui
    class TabSwitcherComponent < ViewComponent::Base
      TAB_BAR_CLASSES = "ks-tab-bar flex flex-wrap justify-center max-sm:flex-nowrap max-sm:overflow-x-auto max-sm:justify-start"
      START_TAB_BAR_CLASSES = "ks-tab-bar flex flex-wrap justify-start max-sm:flex-nowrap max-sm:overflow-x-auto"
      TAB_BAR_CLASSES_BY_ALIGN = { center: TAB_BAR_CLASSES, start: START_TAB_BAR_CLASSES }.freeze
      SHAPE_CLASSES = { pills: "ks-tab-bar-pills", underline: "ks-tab-bar-underline" }.freeze
      TAB_BASE_CLASSES = "ks-tab text-sm transition max-sm:shrink-0 max-sm:whitespace-nowrap"
      SHAPED_TAB_BASE_CLASSES = "ks-tab transition max-sm:shrink-0 max-sm:whitespace-nowrap"
      PANEL_CLASSES = "hidden"
      LAYOUT_CLASSES = "max-sm:flex max-sm:flex-col"
      SUMMARY_CLASSES = "max-sm:order-1 max-sm:[&>:first-child]:mt-0 max-sm:[&>:last-child]:mb-0"
      CONTENT_CLASSES = "max-sm:order-1"

      renders_one :summary
      renders_many :panels

      attr_reader :tabs

      def initialize(tabs:, align: :center, shape: nil)
        @tabs = tabs
        @align = align
        @shape = shape
      end

      def link_tabs?
        tabs.any? && tabs.all?(Hash)
      end

      def classes
        [ TAB_BAR_CLASSES_BY_ALIGN.fetch(@align), SHAPE_CLASSES[@shape] ].compact.join(" ")
      end

      def base_tab_classes
        @shape ? SHAPED_TAB_BASE_CLASSES : TAB_BASE_CLASSES
      end

      def tab_classes
        "#{base_tab_classes} ks-tab-active"
      end

      def count?(tab)
        tab[:count].to_i.positive? || (tab[:show_zero] && !tab[:count].nil?)
      end

      def count_mark(count)
        return render(BadgeComponent.new(label: count.to_s, variant: :info)) unless @shape

        content_tag(:span, count, class: "ks-tab-count")
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
