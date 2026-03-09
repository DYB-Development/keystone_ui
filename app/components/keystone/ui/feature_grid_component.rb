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
        "#{TITLE_BASE_CLASSES} #{KeystoneUi::SurfaceColors[:heading]}"
      end

      def subtitle_classes
        "#{SUBTITLE_BASE_CLASSES} #{KeystoneUi::SurfaceColors[:body]}"
      end

      def subtitle?
        !@subtitle.nil?
      end

      def card_classes
        surface = KeystoneUi::SurfaceColors.current
        accent = KeystoneUi::AccentColors.current
        "#{CARD_LAYOUT_CLASSES} #{surface[:card_border]} #{surface[:card_bg]} #{accent[:hover_border]} #{accent[:dark_hover_border]}"
      end

      def icon_classes
        accent = KeystoneUi::AccentColors.current
        "#{ICON_BASE_CLASSES} #{accent[:bg]} #{accent[:text]} #{accent[:dark_text]}"
      end

      def card_title_classes
        "#{CARD_TITLE_BASE_CLASSES} #{KeystoneUi::SurfaceColors[:heading]}"
      end

      def card_description_classes
        "#{CARD_DESCRIPTION_BASE_CLASSES} #{KeystoneUi::SurfaceColors[:body]}"
      end
    end
  end
end
