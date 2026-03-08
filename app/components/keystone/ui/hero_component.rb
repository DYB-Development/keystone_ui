# frozen_string_literal: true

module Keystone
  module Ui
    class HeroComponent < ViewComponent::Base
      WRAPPER_CLASSES = "relative min-h-screen pt-24"
      INNER_CLASSES = "mx-auto max-w-6xl px-6 py-24 lg:py-32"

      SPLIT_CLASSES = "grid gap-12 lg:grid-cols-2 lg:gap-16 items-center"
      CENTERED_CLASSES = "flex flex-col items-center text-center"

      TITLE_CLASSES = "text-4xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-5xl lg:text-6xl"
      SUBTITLE_CLASSES = "max-w-lg text-lg text-gray-500 dark:text-gray-400"
      BADGE_CLASSES = "inline-flex w-fit items-center gap-2 rounded-full border border-blue-500/20 bg-blue-500/10 px-4 py-1.5 text-sm text-blue-600 dark:text-blue-400"
      ACTIONS_CLASSES = "flex flex-wrap gap-4"

      attr_reader :title, :subtitle, :badge

      def initialize(title:, subtitle: nil, badge: nil, layout: :split)
        @title = title
        @subtitle = subtitle
        @badge = badge
        @layout = layout
      end

      def classes
        WRAPPER_CLASSES
      end

      def inner_classes
        INNER_CLASSES
      end

      def content_classes
        @layout == :centered ? CENTERED_CLASSES : SPLIT_CLASSES
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

      def badge_classes
        BADGE_CLASSES
      end

      def badge?
        !@badge.nil?
      end

      def actions_classes
        ACTIONS_CLASSES
      end
    end
  end
end
