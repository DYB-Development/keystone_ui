# frozen_string_literal: true

module Keystone
  module Ui
    class InfoComponent < ViewComponent::Base
      BUTTON_CLASSES = RadioCardComponent::INFO_BUTTON_CLASSES
      ICON = RadioCardComponent::INFO_ICON
      SUMMARY_CLASSES = "ks-info-summary #{RadioCardComponent::DISCLOSURE_CLASSES} w-64"
      DETAIL_CLASSES = "ks-info-detail ks-radio-card-disclosure hidden absolute top-full right-0 z-20 w-72 text-sm"

      def initialize(summary:)
        @summary = summary
      end

      attr_reader :summary

      def summary_classes
        SUMMARY_CLASSES
      end

      def detail_classes
        DETAIL_CLASSES
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
