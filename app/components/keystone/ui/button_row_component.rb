# frozen_string_literal: true

module Keystone
  module Ui
    class ButtonRowComponent < ViewComponent::Base
      ROW_CLASSES = "flex flex-wrap ks-grid-gap-sm max-sm:*:min-h-11 [&>form]:flex [&>form>*]:flex-1"
      EQUAL_WIDTH_CLASSES = "*:flex-1 *:whitespace-nowrap"
      PHONE_EQUAL_WIDTH_CLASSES = "max-sm:*:flex-1 max-sm:*:whitespace-nowrap"

      def initialize(equal_width: false, class: nil)
        @equal_width = equal_width
        @extra_classes = binding.local_variable_get(:class)
      end

      def row_classes
        [ ROW_CLASSES, equal_width_classes, @extra_classes ].compact.join(" ")
      end

      private

      def equal_width_classes
        return PHONE_EQUAL_WIDTH_CLASSES if @equal_width == :phone

        EQUAL_WIDTH_CLASSES if @equal_width
      end
    end
  end
end
