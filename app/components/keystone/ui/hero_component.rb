# frozen_string_literal: true

module Keystone
  module Ui
    class HeroComponent < ViewComponent::Base
      WRAPPER_CLASSES = "ks-hero relative min-h-screen"
      INNER_CLASSES = "ks-hero-inner mx-auto max-w-6xl"

      CONTENT_COLUMN_CLASSES = "ks-hero-content flex flex-col"
      CENTERED_COLUMN_CLASSES = "items-center"

      SPLIT_CLASSES = "ks-hero-split grid lg:grid-cols-2 items-center"
      CENTERED_CLASSES = "flex flex-col items-center text-center"

      TITLE_BASE_CLASSES = "ks-hero-title text-4xl tracking-tight sm:text-5xl lg:text-6xl"
      SUBTITLE_BASE_CLASSES = "ks-hero-subtitle max-w-lg text-lg"
      BADGE_BASE_CLASSES = "ks-hero-badge inline-flex w-fit items-center text-sm"
      ACTIONS_CLASSES = "ks-hero-actions flex flex-wrap"

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
        return CONTENT_COLUMN_CLASSES unless @layout == :centered

        "#{CONTENT_COLUMN_CLASSES} #{CENTERED_COLUMN_CLASSES}"
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
