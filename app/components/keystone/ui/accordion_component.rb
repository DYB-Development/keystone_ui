# frozen_string_literal: true

module Keystone
  module Ui
    class AccordionComponent < ViewComponent::Base
      BASE_CLASSES = "ks-accordion flex flex-col"
      ITEM_LAYOUT_CLASSES = "ks-accordion-item"
      BUTTON_LAYOUT_CLASSES = "ks-accordion-button flex w-full items-center justify-between text-left transition"
      ANSWER_LAYOUT_CLASSES = "ks-accordion-answer hidden text-sm"
      ICON_LAYOUT_CLASSES = "ks-disclosure-icon shrink-0 transition-transform"

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
        ITEM_LAYOUT_CLASSES
      end

      def button_classes
        "#{BUTTON_LAYOUT_CLASSES} text-surface-900 dark:text-white hover:text-accent-600 dark:hover:text-accent-400"
      end

      def answer_classes
        "#{ANSWER_LAYOUT_CLASSES} text-surface-600 dark:text-surface-400"
      end

      def icon_classes
        "#{ICON_LAYOUT_CLASSES} text-surface-400"
      end

      def caret_icon
        CARET_ICON
      end

      def wrapper_data
        { controller: "accordion" }
      end
    end
  end
end
