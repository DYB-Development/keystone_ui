# frozen_string_literal: true

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
    end
  end
end
