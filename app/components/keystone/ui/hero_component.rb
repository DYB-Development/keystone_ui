# frozen_string_literal: true

module Keystone
  module Ui
    class HeroComponent < ViewComponent::Base
      WRAPPER_CLASSES = "relative min-h-screen pt-24"
      INNER_CLASSES = "mx-auto max-w-6xl px-6 py-24 lg:py-32"

      SPLIT_CLASSES = "grid gap-12 lg:grid-cols-2 lg:gap-16 items-center"
      CENTERED_CLASSES = "flex flex-col items-center text-center"

      TITLE_BASE_CLASSES = "text-4xl font-bold tracking-tight sm:text-5xl lg:text-6xl"
      SUBTITLE_BASE_CLASSES = "max-w-lg text-lg"
      BADGE_BASE_CLASSES = "inline-flex w-fit items-center gap-2 rounded-full border px-4 py-1.5 text-sm"
      ACTIONS_CLASSES = "flex flex-wrap gap-4"

      renders_one :aside

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

      def inner_content_classes
        "flex flex-col gap-8 items-center"
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

      def badge_classes
        "#{BADGE_BASE_CLASSES} border-accent-500/20 bg-accent-500/10 text-accent-600 dark:text-accent-400"
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
