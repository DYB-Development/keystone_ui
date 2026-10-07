# frozen_string_literal: true

module Keystone
  module Ui
    class ColumnPickerComponent < ViewComponent::Base
      WRAPPER_CLASSES = "relative inline-block"
      TRIGGER_CLASSES = "ks-menu-trigger inline-flex items-center text-sm"
      MENU_CLASSES = "ks-menu absolute right-0 z-10 w-56 hidden"
      OPTION_CLASSES = "ks-menu-option flex items-center text-sm cursor-pointer"
      CHECKBOX_CLASSES = "ks-menu-checkbox"
      OPTION_HIDDEN_CLASSES = "ks-menu-option-hidden"
      OPTION_ROW_CLASSES = "flex items-center"
      MOVE_BUTTON_CLASSES = "ks-menu-move text-sm"

      COLUMNS_ICON = <<~SVG.freeze
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-4 h-4">
          <path fill-rule="evenodd" d="M.99 5.24A2.25 2.25 0 0 1 3.25 3h13.5A2.25 2.25 0 0 1 19 5.25l.01 9.5A2.25 2.25 0 0 1 16.76 17H3.26A2.25 2.25 0 0 1 1 14.75l-.01-9.5Zm8.26 9.52v-3.5l-2.25.01v3.5l2.25-.01Zm1.5 0 2.25.01v-3.5l-2.25-.01v3.5Zm-1.5-5v-3.5l-2.25.01v3.49l2.25.01Zm1.5-.01 2.25.01v-3.5l-2.25-.01v3.5Z" clip-rule="evenodd" />
        </svg>
      SVG

      attr_reader :save_url

      def initialize(columns:, hidden_columns: [], save_url: nil, layout: nil)
        @layout = layout || SavedLayout.new(columns: columns, value: nil, default_hidden: hidden_columns)
        @save_url = save_url
      end

      def hideable_columns
        @layout.columns.select(&:hideable?)
      end

      def hidden?(key)
        @layout.hidden?(key)
      end

      def option_classes(key)
        hidden?(key) ? "#{OPTION_CLASSES} #{OPTION_HIDDEN_CLASSES}" : OPTION_CLASSES
      end
    end
  end
end
