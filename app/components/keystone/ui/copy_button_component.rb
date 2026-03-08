# frozen_string_literal: true

module Keystone
  module Ui
    class CopyButtonComponent < ViewComponent::Base
      BUTTON_CLASSES = "inline-flex items-center gap-1.5 rounded-md border border-gray-300 bg-white px-3 py-1.5 text-sm font-medium text-gray-700 transition hover:bg-gray-50 dark:border-zinc-600 dark:bg-zinc-800 dark:text-gray-300 dark:hover:bg-zinc-700"

      COPY_ICON = <<~SVG.freeze
        <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" /></svg>
      SVG

      attr_reader :text, :label, :success_message, :error_message

      def initialize(text:, label: "Copy", success_message: "Copied!", error_message: "Failed!")
        @text = text
        @label = label
        @success_message = success_message
        @error_message = error_message
      end

      def classes
        BUTTON_CLASSES
      end

      def copy_icon
        COPY_ICON
      end
    end
  end
end
