# frozen_string_literal: true

module Keystone
  module Ui
    class ButtonRowComponent < ViewComponent::Base
      ROW_CLASSES = "flex ks-grid-gap-sm"

      def row_classes
        ROW_CLASSES
      end
    end
  end
end
