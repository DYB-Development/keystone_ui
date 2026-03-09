# frozen_string_literal: true

module Keystone
  module Ui
    class FeatureGridComponent < ViewComponent::Base
      GRID_CLASSES = "grid gap-6 sm:grid-cols-2 lg:grid-cols-3"
      TITLE_CLASSES = "mb-4 text-center text-3xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-4xl"
      SUBTITLE_CLASSES = "mx-auto mb-16 max-w-2xl text-center text-lg text-gray-500 dark:text-gray-400"
      CARD_BASE_CLASSES = "rounded-xl border border-gray-200 bg-white p-6 transition dark:border-zinc-700 dark:bg-zinc-800"
      ICON_BASE_CLASSES = "mb-4 flex size-10 items-center justify-center rounded-lg text-lg"
      CARD_TITLE_CLASSES = "mb-2 text-lg font-semibold text-gray-900 dark:text-white"
      CARD_DESCRIPTION_CLASSES = "text-sm text-gray-500 dark:text-gray-400"

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
        TITLE_CLASSES
      end

      def subtitle_classes
        SUBTITLE_CLASSES
      end

      def subtitle?
        !@subtitle.nil?
      end

      def card_classes
        accent = KeystoneUi::AccentColors.current
        "#{CARD_BASE_CLASSES} #{accent[:hover_border]} #{accent[:dark_hover_border]}"
      end

      def icon_classes
        accent = KeystoneUi::AccentColors.current
        "#{ICON_BASE_CLASSES} #{accent[:bg]} #{accent[:text]} #{accent[:dark_text]}"
      end

      def card_title_classes
        CARD_TITLE_CLASSES
      end

      def card_description_classes
        CARD_DESCRIPTION_CLASSES
      end
    end
  end
end
