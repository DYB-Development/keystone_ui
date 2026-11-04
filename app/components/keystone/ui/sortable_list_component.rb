# frozen_string_literal: true

module Keystone
  module Ui
    class SortableListComponent < ViewComponent::Base
      ROW_CLASSES = "ks-value-list-row items-center data-dragging:opacity-50"
      LABEL_CLASSES = "ks-paragraph min-w-0 flex-1"
      HANDLE_CLASSES = "ks-tone-muted flex size-11 shrink-0 cursor-grab touch-none select-none items-center justify-center"
      MOVE_BUTTON_CLASSES = "ks-button ks-button-secondary ks-button-sm size-11 shrink-0"
      ICON_CLASSES = "size-5"
      STATUS_CLASSES = "sr-only"

      def initialize(name:, label:, rows:)
        @name = name
        @label = label
        @rows = rows
      end
    end
  end
end
