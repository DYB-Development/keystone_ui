# frozen_string_literal: true

require "json"

module Keystone
  module Ui
    class LineChartComponent < ViewComponent::Base
      def initialize(series:, labels:, height: :md)
        @series = series
        @labels = labels
        @height = height
      end

      def chart_data
        { labels: @labels, datasets: @series.map { |s| { label: s[:name], data: s[:data] } } }
      end

      def chart_data_json
        chart_data.to_json
      end
    end
  end
end
