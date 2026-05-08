# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::ChartCardComponentTest < Minitest::Test
  def test_returns_card_classes
    component = Keystone::Ui::ChartCardComponent.new(title: "Throughput")

    assert_includes component.classes, "rounded-xl"
    assert_includes component.classes, "border"
    assert_includes component.classes, "p-6"
  end

  def test_exposes_title
    component = Keystone::Ui::ChartCardComponent.new(title: "Latency")

    assert_equal "Latency", component.title
  end

  def test_exposes_title_classes
    component = Keystone::Ui::ChartCardComponent.new(title: "X")

    assert_includes component.title_classes, "text-sm"
    assert_includes component.title_classes, "font-medium"
  end

  def test_defaults_chart_height_to_h_64
    component = Keystone::Ui::ChartCardComponent.new(title: "X")

    assert_equal "h-64", component.chart_height_class
  end

  def test_accepts_custom_height
    component = Keystone::Ui::ChartCardComponent.new(title: "X", height: :lg)

    assert_equal "h-96", component.chart_height_class
  end

  def test_accepts_sm_height
    component = Keystone::Ui::ChartCardComponent.new(title: "X", height: :sm)

    assert_equal "h-48", component.chart_height_class
  end

  def test_raises_on_invalid_height
    component = Keystone::Ui::ChartCardComponent.new(title: "X", height: :xl)

    assert_raises(KeyError) { component.chart_height_class }
  end
end
