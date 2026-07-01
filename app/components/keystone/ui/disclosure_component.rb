# frozen_string_literal: true

module Keystone
  module Ui
    class DisclosureComponent < ViewComponent::Base
      WRAPPER_CLASSES = "group rounded-xl border border-surface-200 dark:border-surface-700"
      SUMMARY_CLASSES = "flex cursor-pointer list-none items-center justify-between gap-4 px-6 py-4 font-semibold text-surface-900 [&::-webkit-details-marker]:hidden dark:text-white"
      ICON_CLASSES = "h-4 w-4 shrink-0 text-surface-400 transition-transform group-open:rotate-180"
      BODY_CLASSES = "px-6 pb-4 text-sm text-surface-600 dark:text-surface-400"

      CARET_ICON = <<~SVG.freeze
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" /></svg>
      SVG

      renders_one :summary

      def initialize(open: false)
        @open = open
      end

      def open?
        @open
      end

      def wrapper_classes
        WRAPPER_CLASSES
      end

      def summary_classes
        SUMMARY_CLASSES
      end

      def icon_classes
        ICON_CLASSES
      end

      def body_classes
        BODY_CLASSES
      end

      def caret_icon
        CARET_ICON
      end
    end
  end
end
