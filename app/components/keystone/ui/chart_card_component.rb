# frozen_string_literal: true

module Keystone
  module Ui
    class ChartCardComponent < ViewComponent::Base
      CARD_CLASSES = "ks-metric-card"
      TITLE_CLASSES = "ks-chart-card-title text-sm font-medium text-gray-500 dark:text-gray-400 mb-4"

      HEIGHT_CLASSES = {
        sm: "h-48",
        md: "h-64",
        lg: "h-96"
      }.freeze

      attr_reader :title

      def initialize(title:, height: :md)
        @title = title
        @height = height
      end

      def classes
        CARD_CLASSES
      end

      def title_classes
        TITLE_CLASSES
      end

      def chart_height_class
        HEIGHT_CLASSES.fetch(@height)
      end
    end
  end
end
