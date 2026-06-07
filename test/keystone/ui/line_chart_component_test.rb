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

  def test_height_class_maps_size_to_a_height
    component = Keystone::Ui::LineChartComponent.new(series: [], labels: [], height: :lg)

    assert_equal "h-96", component.height_class
  end

  def test_container_is_a_relative_shrinkable_box
    component = Keystone::Ui::LineChartComponent.new(series: [], labels: [])

    assert_includes component.container_classes, "relative"
    assert_includes component.container_classes, "min-w-0"
  end
end
