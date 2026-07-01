# frozen_string_literal: true

require "json"

module Keystone
  module Ui
    class LineChartComponent < ViewComponent::Base
      HEIGHT_CLASSES = {
        sm: "h-48",
        md: "h-64",
        lg: "h-96"
      }.freeze

      def initialize(series:, labels:, height: :md)
        @series = series
        @labels = labels
        @height = height
      end

      def chart_data
        { labels: @labels, datasets: @series.map { |s| dataset_for(s) } }
      end

      def chart_data_json
        chart_data.to_json
      end

      def height_class
        HEIGHT_CLASSES.fetch(@height)
      end

      def container_classes
        "#{height_class} relative w-full min-w-0"
      end

      private

      def dataset_for(series)
        dataset = { label: series[:name], data: series[:data] }
        dataset[:borderColor] = series[:color] if series[:color]
        dataset
      end
    end
  end
end
