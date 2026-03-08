# frozen_string_literal: true

module Keystone
  module Ui
    class ModalComponent < ViewComponent::Base
      BACKDROP_CLASSES = "hidden fixed inset-0 z-50 flex items-center justify-center bg-black/60"
      PANEL_CLASSES = "rounded-xl border border-gray-200 bg-white p-6 w-full mx-4 max-h-[80vh] flex flex-col dark:border-zinc-700 dark:bg-zinc-800"
      HEADER_CLASSES = "flex items-center justify-between mb-4"
      TITLE_CLASSES = "text-lg font-semibold text-gray-900 dark:text-gray-200"
      CLOSE_BUTTON_CLASSES = "text-gray-400 hover:text-gray-600 dark:hover:text-gray-200"
      BODY_CLASSES = "overflow-auto flex-1"

      SIZE_CLASSES = {
        sm: "max-w-sm",
        md: "max-w-lg",
        lg: "max-w-2xl",
        xl: "max-w-4xl"
      }.freeze

      CLOSE_ICON = <<~SVG.freeze
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
      SVG

      attr_reader :title

      def initialize(title:, size: :md)
        @title = title
        @size = size
      end

      def backdrop_classes
        BACKDROP_CLASSES
      end

      def panel_classes
        [PANEL_CLASSES, size_class].join(" ")
      end

      def header_classes
        HEADER_CLASSES
      end

      def title_classes
        TITLE_CLASSES
      end

      def close_button_classes
        CLOSE_BUTTON_CLASSES
      end

      def body_classes
        BODY_CLASSES
      end

      def size_class
        SIZE_CLASSES.fetch(@size)
      end

      def close_icon
        CLOSE_ICON
      end
    end
  end
end
