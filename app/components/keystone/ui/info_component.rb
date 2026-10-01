# frozen_string_literal: true

module Keystone
  module Ui
    class InfoComponent < ViewComponent::Base
      BUTTON_CLASSES = RadioCardComponent::INFO_BUTTON_CLASSES
      ICON = RadioCardComponent::INFO_ICON
      SUMMARY_CLASSES = "ks-info-summary #{RadioCardComponent::DISCLOSURE_CLASSES.sub("ks-radio-card-disclosure", "ks-radio-card-disclosure")} w-64"

      def initialize(summary:)
        @summary = summary
      end

      attr_reader :summary

      def summary_classes
        SUMMARY_CLASSES
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
