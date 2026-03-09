# frozen_string_literal: true

module Keystone
  module Ui
    class AccordionComponent < ViewComponent::Base
      BASE_CLASSES = "flex flex-col gap-4"
      ITEM_CLASSES = "rounded-xl border border-gray-200 dark:border-zinc-700"
      BUTTON_BASE_CLASSES = "flex w-full items-center justify-between px-6 py-4 text-left font-semibold text-gray-900 dark:text-white transition"
      ANSWER_CLASSES = "hidden px-6 pb-4 text-sm text-gray-600 dark:text-gray-400"
      ICON_CLASSES = "shrink-0 text-gray-400 transition-transform"

      CARET_ICON = <<~SVG.freeze
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" /></svg>
      SVG

      attr_reader :items

      def initialize(items: [])
        @items = items
      end

      def classes
        BASE_CLASSES
      end

      def item_classes
        ITEM_CLASSES
      end

      def button_classes
        accent = KeystoneUi::AccentColors.current
        "#{BUTTON_BASE_CLASSES} #{accent[:hover_text]} #{accent[:dark_hover_text]}"
      end

      def answer_classes
        ANSWER_CLASSES
      end

      def icon_classes
        ICON_CLASSES
      end

      def caret_icon
        CARET_ICON
      end
    end
  end
end
