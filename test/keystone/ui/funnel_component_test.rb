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
end
