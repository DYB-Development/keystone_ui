# frozen_string_literal: true

module Keystone
  module Ui
    class FeatureGridComponent < ViewComponent::Base
      GRID_CLASSES = "grid gap-6 sm:grid-cols-2 lg:grid-cols-3"
      TITLE_BASE_CLASSES = "mb-4 text-center text-3xl font-bold tracking-tight sm:text-4xl"
      SUBTITLE_BASE_CLASSES = "mx-auto mb-16 max-w-2xl text-center text-lg"
      CARD_LAYOUT_CLASSES = "rounded-xl border p-6 transition"
      ICON_BASE_CLASSES = "mb-4 flex size-10 items-center justify-center rounded-lg text-lg"
      CARD_TITLE_BASE_CLASSES = "mb-2 text-lg font-semibold"
      CARD_DESCRIPTION_BASE_CLASSES = "text-sm"

      attr_reader :title, :subtitle, :features

      def initialize(title:, features:, subtitle: nil)
        @title = title
        @subtitle = subtitle
        @features = features
      end

      def classes
        GRID_CLASSES
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

      def card_classes
        "#{CARD_LAYOUT_CLASSES} border-surface-200 dark:border-surface-700 bg-white dark:bg-surface-800 hover:border-accent-500/50 dark:hover:border-accent-500/50"
      end

      def icon_classes
        "#{ICON_BASE_CLASSES} bg-accent-500/10 text-accent-600 dark:text-accent-400"
      end

      def card_title_classes
        "#{CARD_TITLE_BASE_CLASSES} text-surface-900 dark:text-white"
      end

      def card_description_classes
        "#{CARD_DESCRIPTION_BASE_CLASSES} text-surface-500 dark:text-surface-400"
      end
    end
  end
end
