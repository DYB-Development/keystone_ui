# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::ChartCardComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}


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

  def test_card_classes_render_the_ks_metric_card_class
    assert_includes Keystone::Ui::ChartCardComponent::CARD_CLASSES, "ks-metric-card"
  end

  def test_card_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::ChartCardComponent::CARD_CLASSES
  end

  def test_title_classes_render_the_ks_chart_card_title_class
    assert_includes Keystone::Ui::ChartCardComponent::TITLE_CLASSES, "ks-chart-card-title"
  end
end
