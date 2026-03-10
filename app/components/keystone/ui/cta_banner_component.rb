# frozen_string_literal: true

module Keystone
  module Ui
    class CtaBannerComponent < ViewComponent::Base
      CARD_LAYOUT_CLASSES = "rounded-2xl border px-6 py-12 text-center lg:px-16 lg:py-16"
      TITLE_BASE_CLASSES = "mb-4 text-3xl font-bold tracking-tight sm:text-4xl"
      SUBTITLE_BASE_CLASSES = "mx-auto mb-8 max-w-2xl text-lg"
      ACTIONS_CLASSES = "flex flex-wrap justify-center gap-4"

      attr_reader :title, :subtitle

      def initialize(title:, subtitle: nil)
        @title = title
        @subtitle = subtitle
      end

      def classes
        "#{CARD_LAYOUT_CLASSES} border-surface-200 dark:border-surface-700 bg-surface-50 dark:bg-surface-800"
      end

      def title_classes
        "#{TITLE_BASE_CLASSES} text-surface-900 dark:text-white"
      end

      def subtitle_classes
        "#{SUBTITLE_BASE_CLASSES} text-surface-500 dark:text-surface-400"
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
