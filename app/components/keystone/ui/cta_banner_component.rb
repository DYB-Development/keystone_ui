# frozen_string_literal: true

module Keystone
  module Ui
    class CtaBannerComponent < ViewComponent::Base
      CARD_CLASSES = "rounded-2xl border border-gray-200 bg-gray-50 px-6 py-12 text-center lg:px-16 lg:py-16 dark:border-zinc-700 dark:bg-zinc-800"
      TITLE_CLASSES = "mb-4 text-3xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-4xl"
      SUBTITLE_CLASSES = "mx-auto mb-8 max-w-2xl text-lg text-gray-500 dark:text-gray-400"
      ACTIONS_CLASSES = "flex flex-wrap justify-center gap-4"

      attr_reader :title, :subtitle

      def initialize(title:, subtitle: nil)
        @title = title
        @subtitle = subtitle
      end

      def classes
        CARD_CLASSES
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

      def actions_classes
        ACTIONS_CLASSES
      end
    end
  end
end
