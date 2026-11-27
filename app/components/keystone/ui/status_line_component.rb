# frozen_string_literal: true

module Keystone
  module Ui
    class StatusLineComponent < ViewComponent::Base
      LINE_CLASSES = "ks-status-line flex items-center"
      ICON_CLASSES = {
        true => "ks-status-icon ks-status-icon-pass inline-flex items-center justify-center shrink-0 size-4",
        false => "ks-status-icon ks-status-icon-fail inline-flex items-center justify-center shrink-0 size-4"
      }.freeze
      ICON_LABELS = { true => "Pass", false => "Fail" }.freeze

      def initialize(passed:, text:)
        @passed = passed ? true : false
        @text = text
      end

      attr_reader :text

      def icon_classes
        ICON_CLASSES.fetch(@passed)
      end

      def icon_label
        ICON_LABELS.fetch(@passed)
      end
    end
  end
end
