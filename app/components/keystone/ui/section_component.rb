# frozen_string_literal: true

module Keystone
  module Ui
    class SectionComponent < ViewComponent::Base
      SPACING_CLASSES = { sm: "mt-4", md: "mt-6", lg: "mt-8" }.freeze
      HEADER_CLASSES = "flex items-center justify-between mb-4"
      TITLE_CLASSES = "text-lg font-semibold text-gray-900 dark:text-white"
      SUBTITLE_CLASSES = "mt-1 text-sm text-gray-500 dark:text-gray-400"
      ACTION_CLASSES = "text-sm text-indigo-600 hover:text-indigo-900 dark:text-indigo-400 dark:hover:text-indigo-300"

      def initialize(title: nil, subtitle: nil, action: nil, spacing: :md)
        @title = title
        @subtitle = subtitle
        @action = action
        @spacing = spacing
      end

      def spacing_class
        SPACING_CLASSES.fetch(@spacing)
      end

      def header?
        !@title.nil?
      end
    end
  end
end
