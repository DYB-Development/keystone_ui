# frozen_string_literal: true

module Keystone
  module Ui
    class ColumnPickerComponent < ViewComponent::Base
      WRAPPER_CLASSES = "relative inline-block"
      TRIGGER_CLASSES = "ks-menu-trigger inline-flex items-center text-sm"
      MENU_CLASSES = "ks-menu absolute right-0 z-10 w-56 hidden"
      OPTION_CLASSES = "ks-menu-option flex items-center text-sm cursor-pointer"
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
