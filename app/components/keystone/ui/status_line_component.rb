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
      MARK_CLASSES = "size-3"

      def initialize(passed:, text:)
        @passed = passed && true
        @text = text
      end

      attr_reader :text

      def result?
        !@passed.nil?
      end

      def icon_classes
        ICON_CLASSES.fetch(@passed)
      end

      def icon_label
        ICON_LABELS.fetch(@passed)
      end

      def mark_path
        if @passed
          "M16.704 4.153a.75.75 0 0 1 .143 1.052l-8 10.5a.75.75 0 0 1-1.127.075l-4.5-4.5a.75.75 0 0 1 1.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 0 1 1.05-.143Z"
        else
          "M6.28 5.22a.75.75 0 0 0-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 1 0 1.06 1.06L10 11.06l3.72 3.72a.75.75 0 1 0 1.06-1.06L11.06 10l3.72-3.72a.75.75 0 0 0-1.06-1.06L10 8.94 6.28 5.22Z"
        end
      end
    end
  end
end
