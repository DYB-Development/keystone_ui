# frozen_string_literal: true

module Keystone
  module Ui
    class InfoComponent < ViewComponent::Base
      BUTTON_CLASSES = RadioCardComponent::INFO_BUTTON_CLASSES
      ICON = RadioCardComponent::INFO_ICON

      def initialize(summary:)
        @summary = summary
      end

      def button_classes
        BUTTON_CLASSES
      end

      def icon
        ICON
      end
    end
  end
end
