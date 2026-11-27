# frozen_string_literal: true

module Keystone
  module Ui
    class StatusLineComponent < ViewComponent::Base
      LINE_CLASSES = "ks-status-line flex items-center"
      ICON_CLASSES = "ks-status-icon ks-status-icon-pass inline-flex items-center justify-center shrink-0 size-4"

      def initialize(passed:, text:)
        @passed = passed
        @text = text
      end

      attr_reader :text
    end
  end
end
