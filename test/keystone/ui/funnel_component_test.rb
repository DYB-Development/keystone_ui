# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::FunnelComponentTest < Minitest::Test
  def test_exposes_steps
    steps = [ { label: "Visitors", value: 10_000 } ]
    component = Keystone::Ui::FunnelComponent.new(steps: steps)

    assert_equal steps, component.steps
  end

  def test_top_layer_spans_full_width
    component = Keystone::Ui::FunnelComponent.new(steps: [
      { label: "Visitors", value: 10_000 }
    ])

    assert_equal 100, component.layers.first.width_percent
  end

  def test_lower_layer_width_is_relative_to_the_top
    component = Keystone::Ui::FunnelComponent.new(steps: [
      { label: "Visitors", value: 10_000 },
      { label: "Signups", value: 4_500 }
    ])

    assert_equal 45, component.layers.last.width_percent
  end

  def test_top_layer_has_no_conversion
    component = Keystone::Ui::FunnelComponent.new(steps: [
      { label: "Visitors", value: 10_000 }
    ])

    assert_nil component.layers.first.conversion_percent
  end

  def test_lower_layer_conversion_is_relative_to_the_previous_step
    component = Keystone::Ui::FunnelComponent.new(steps: [
      { label: "Visitors", value: 10_000 },
      { label: "Signups", value: 4_500 },
      { label: "Activated", value: 1_500 }
    ])

    assert_equal 33, component.layers.last.conversion_percent
  end

  def test_zero_top_value_yields_zero_width
    component = Keystone::Ui::FunnelComponent.new(steps: [
      { label: "Visitors", value: 0 },
      { label: "Signups", value: 0 }
    ])

    assert_equal 0, component.layers.last.width_percent
  end

  def test_bar_classes_use_accent_fill
    component = Keystone::Ui::FunnelComponent.new(steps: [
      { label: "Visitors", value: 10_000 }
    ])

    assert_includes component.bar_classes, "bg-accent-500"
  end

  def test_label_row_pushes_label_and_value_to_the_edges
    component = Keystone::Ui::FunnelComponent.new(steps: [
      { label: "Visitors", value: 10_000 }
    ])

    assert_includes component.row_classes, "justify-between"
  end

  def test_transition_classes_render_a_centered_caption
    component = Keystone::Ui::FunnelComponent.new(steps: [
      { label: "Visitors", value: 10_000 }
    ])

    assert_includes component.transition_classes, "text-center"
  end
end
