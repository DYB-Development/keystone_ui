# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::FunnelComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

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

  def test_first_layer_defaults_to_the_accent_color
    component = Keystone::Ui::FunnelComponent.new(steps: [
      { label: "Visitors", value: 10_000 }
    ])

    assert_equal "ks-funnel-bar-accent", component.layers.first.color_classes
  end

  def test_second_layer_defaults_to_the_second_palette_color
    component = Keystone::Ui::FunnelComponent.new(steps: [
      { label: "Visitors", value: 10_000 },
      { label: "Signups", value: 4_500 }
    ])

    assert_equal "ks-funnel-bar-sky", component.layers.last.color_classes
  end

  def test_palette_starts_again_after_its_last_color
    steps = Keystone::Ui::FunnelComponent::STEP_COLOR_CLASSES.size.times.map do |n|
      { label: "Step #{n}", value: 100 - n }
    end
    component = Keystone::Ui::FunnelComponent.new(steps: steps + [ { label: "Last", value: 1 } ])

    assert_equal "ks-funnel-bar-accent", component.layers.last.color_classes
  end

  def test_step_color_overrides_the_palette
    component = Keystone::Ui::FunnelComponent.new(steps: [
      { label: "Visitors", value: 10_000, color: :rose }
    ])

    assert_equal "ks-funnel-bar-rose", component.layers.first.color_classes
  end

  def test_zero_top_value_yields_zero_width
    component = Keystone::Ui::FunnelComponent.new(steps: [
      { label: "Visitors", value: 0 },
      { label: "Signups", value: 0 }
    ])

    assert_equal 0, component.layers.last.width_percent
  end

  def test_bar_classes_leave_the_fill_to_each_step
    component = Keystone::Ui::FunnelComponent.new(steps: [
      { label: "Visitors", value: 10_000 }
    ])

    refute_includes component.bar_classes, "bg-accent-500"
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




  def test_shape_defaults_to_bars
    component = Keystone::Ui::FunnelComponent.new(steps: [ { label: "Visitors", value: 10_000 } ])
    
    assert_equal :bars, component.shape
  end

  def test_joined_shape_draws_one_joined_funnel
    component = Keystone::Ui::FunnelComponent.new(steps: [ { label: "Visitors", value: 10_000 } ], shape: :joined)
    
    assert component.joined?
  end

  def test_an_unknown_shape_is_refused
    assert_raises(ArgumentError) { Keystone::Ui::FunnelComponent.new(steps: [ { label: "Visitors", value: 10_000 } ], shape: :pyramid) }
  end

  def test_lower_layer_knows_the_width_of_the_step_above
    component = Keystone::Ui::FunnelComponent.new(steps: [ { label: "Contacts", value: 161 }, { label: "Conversations", value: 42 } ])
    
    assert_equal 100, component.layers.last.previous_width_percent
  end

  def test_band_narrows_from_the_step_above_to_the_step_below
    component = Keystone::Ui::FunnelComponent.new(steps: [ { label: "Contacts", value: 161 }, { label: "Conversations", value: 42 } ], shape: :joined)
    
    assert_equal "polygon(0% 0, 100% 0, 63% 100%, 37% 100%)", component.band_clip_path(component.layers.last)
  end

  def test_joined_classes_render_the_ks_funnel_joined_class
    assert_includes Keystone::Ui::FunnelComponent::JOINED_CLASSES, "ks-funnel-joined"
  end

  def test_band_classes_render_the_ks_funnel_band_class
    assert_includes Keystone::Ui::FunnelComponent::BAND_CLASSES, "ks-funnel-band"
  end

  def test_band_label_classes_render_the_ks_funnel_band_label_class
    assert_includes Keystone::Ui::FunnelComponent::BAND_LABEL_CLASSES, "ks-funnel-band-label"
  end

  def test_container_classes_render_the_ks_funnel_class
    assert_includes Keystone::Ui::FunnelComponent::CONTAINER_CLASSES, "ks-funnel"
  end

  def test_container_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::FunnelComponent::CONTAINER_CLASSES
  end

  def test_layer_classes_render_the_ks_funnel_layer_class
    assert_includes Keystone::Ui::FunnelComponent::LAYER_CLASSES, "ks-funnel-layer"
  end

  def test_layer_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::FunnelComponent::LAYER_CLASSES
  end

  def test_row_classes_render_the_ks_funnel_row_class
    assert_includes Keystone::Ui::FunnelComponent::ROW_CLASSES, "ks-funnel-row"
  end

  def test_row_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::FunnelComponent::ROW_CLASSES
  end

  def test_label_classes_render_the_ks_funnel_label_class
    assert_includes Keystone::Ui::FunnelComponent::LABEL_CLASSES, "ks-funnel-label"
  end

  def test_label_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::FunnelComponent::LABEL_CLASSES
  end

  def test_value_classes_render_the_ks_funnel_value_class
    assert_includes Keystone::Ui::FunnelComponent::VALUE_CLASSES, "ks-funnel-value"
  end

  def test_value_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::FunnelComponent::VALUE_CLASSES
  end

  def test_bar_classes_render_the_ks_funnel_bar_class
    assert_includes Keystone::Ui::FunnelComponent::BAR_CLASSES, "ks-funnel-bar"
  end

  def test_bar_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::FunnelComponent::BAR_CLASSES
  end

  def test_transition_classes_render_the_ks_funnel_transition_class
    assert_includes Keystone::Ui::FunnelComponent::TRANSITION_CLASSES, "ks-funnel-transition"
  end

  def test_transition_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::FunnelComponent::TRANSITION_CLASSES
  end

  def test_step_color_classes_map_to_look_classes
    assert_equal({ accent: "ks-funnel-bar-accent", sky: "ks-funnel-bar-sky", violet: "ks-funnel-bar-violet", amber: "ks-funnel-bar-amber", rose: "ks-funnel-bar-rose" }, Keystone::Ui::FunnelComponent::STEP_COLOR_CLASSES)
  end
end
