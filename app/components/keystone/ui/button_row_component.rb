# frozen_string_literal: true

module Keystone
  module Ui
    class ButtonRowComponent < ViewComponent::Base
      ROW_CLASSES = "flex flex-wrap ks-grid-gap-sm max-sm:*:min-h-11"
      EQUAL_WIDTH_CLASSES = "*:flex-1"

      def initialize(equal_width: false)
        @equal_width = equal_width
      end

      def row_classes
        [ ROW_CLASSES, (EQUAL_WIDTH_CLASSES if @equal_width) ].compact.join(" ")
      end
    end
  end
end
