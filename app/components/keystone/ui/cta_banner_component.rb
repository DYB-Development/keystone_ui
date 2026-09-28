# frozen_string_literal: true

module Keystone
  module Ui
    class CtaBannerComponent < ViewComponent::Base
      CARD_LAYOUT_CLASSES = "ks-cta-banner text-center"
      TITLE_BASE_CLASSES = "ks-cta-banner-title text-3xl tracking-tight sm:text-4xl"
      SUBTITLE_BASE_CLASSES = "ks-cta-banner-subtitle mx-auto max-w-2xl text-lg"
      ACTIONS_CLASSES = "ks-cta-banner-actions flex flex-wrap justify-center"

      attr_reader :title, :subtitle

      def initialize(title:, subtitle: nil)
        @title = title
        @subtitle = subtitle
      end

      def classes
        CARD_LAYOUT_CLASSES
      end

      def title_classes
        TITLE_BASE_CLASSES
      end

      def subtitle_classes
        SUBTITLE_BASE_CLASSES
      end

      def subtitle?
        !@subtitle.nil?
      end

      def actions_classes
        ACTIONS_CLASSES
      end
    end
  end
end
