# frozen_string_literal: true

require "date"
require "json"

module Keystone
  module Ui
    class LineChartComponent < ViewComponent::Base
      HEIGHT_CLASSES = {
        sm: "h-48",
        md: "h-64",
        lg: "h-96"
      }.freeze

      DASH_PATTERN = [ 6, 6 ].freeze
      EPOCH = Date.new(1970, 1, 1)

      def initialize(series:, labels: nil, dates: nil, height: :md)
        @series = series
        @labels = labels
        @dates = dates
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
        dataset = { label: series[:name], data: points_for(series[:data]) }
        dataset[:borderColor] = series[:color] if series[:color]
        dataset[:borderDash] = DASH_PATTERN if series[:dashed]
        dataset
      end

      def points_for(values)
        return values unless @dates

        @dates.zip(values).map { |date, value| { x: (date.to_date - EPOCH).to_i, y: value } }
      end
    end
  end
end
