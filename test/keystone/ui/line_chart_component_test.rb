# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::LineChartComponentTest < Minitest::Test
  def test_builds_datasets_from_series
    component = Keystone::Ui::LineChartComponent.new(
      series: [ { name: "Leads", data: [ 1, 2, 3 ] } ],
      labels: %w[Mon Tue Wed]
    )

    assert_equal [ { label: "Leads", data: [ 1, 2, 3 ] } ], component.chart_data[:datasets]
  end

  def test_chart_data_includes_labels
    component = Keystone::Ui::LineChartComponent.new(series: [], labels: %w[Mon Tue Wed])

    assert_equal %w[Mon Tue Wed], component.chart_data[:labels]
  end

  def test_chart_data_json_serializes_chart_data
    component = Keystone::Ui::LineChartComponent.new(series: [ { name: "Leads", data: [ 1, 2 ] } ], labels: %w[Mon Tue])

    assert_equal component.chart_data.to_json, component.chart_data_json
  end
end
