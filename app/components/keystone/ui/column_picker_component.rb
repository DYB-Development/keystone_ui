# frozen_string_literal: true

module Keystone
  module Ui
    class ColumnPickerComponent < ViewComponent::Base
      WRAPPER_CLASSES = "relative inline-block"
      TRIGGER_CLASSES = "inline-flex items-center gap-1 rounded-md border px-3 py-2 text-sm border-gray-300 bg-white text-gray-900 dark:border-zinc-700 dark:bg-zinc-900 dark:text-white"
      MENU_CLASSES = "absolute right-0 z-10 mt-1 w-56 rounded-md border border-gray-200 bg-white shadow-lg dark:border-zinc-700 dark:bg-zinc-900 hidden"
      OPTION_CLASSES = "flex items-center gap-2 px-3 py-2 text-sm text-gray-700 hover:bg-gray-50 dark:text-gray-300 dark:hover:bg-zinc-800 cursor-pointer"
      CHECKBOX_CLASSES = "rounded border-gray-300 text-accent-600 focus:ring-accent-500 dark:border-zinc-600"

      COLUMNS_ICON = <<~SVG.freeze
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-4 h-4">
          <path fill-rule="evenodd" d="M.99 5.24A2.25 2.25 0 0 1 3.25 3h13.5A2.25 2.25 0 0 1 19 5.25l.01 9.5A2.25 2.25 0 0 1 16.76 17H3.26A2.25 2.25 0 0 1 1 14.75l-.01-9.5Zm8.26 9.52v-3.5l-2.25.01v3.5l2.25-.01Zm1.5 0 2.25.01v-3.5l-2.25-.01v3.5Zm-1.5-5v-3.5l-2.25.01v3.49l2.25.01Zm1.5-.01 2.25.01v-3.5l-2.25-.01v3.5Z" clip-rule="evenodd" />
        </svg>
      SVG

      attr_reader :save_url

      def initialize(columns:, hidden_columns: [], save_url: nil)
        @columns = columns
        @hidden_keys = Array(hidden_columns).map(&:to_sym).to_set
        @save_url = save_url
      end

      def hideable_columns
        @columns.select(&:hideable?)
      end

      def hidden?(key)
        @hidden_keys.include?(key.to_sym)
      end
    end
  end
end
