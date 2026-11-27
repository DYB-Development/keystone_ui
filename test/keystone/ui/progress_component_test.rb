# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::ProgressComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_exposes_label
    component = Keystone::Ui::ProgressComponent.new(value: 3, max: 5, label: "Question 3 of 5")

    assert_equal "Question 3 of 5", component.label
  end

  def test_percent_reflects_value_over_max
    component = Keystone::Ui::ProgressComponent.new(value: 3, max: 5)

    assert_equal 60, component.percent
  end

  def test_percent_caps_at_one_hundred
    component = Keystone::Ui::ProgressComponent.new(value: 7, max: 5)

    assert_equal 100, component.percent
  end



  def test_label_classes_render_a_small_caption
    component = Keystone::Ui::ProgressComponent.new(value: 3, max: 5, label: "Question 3 of 5")

    assert_includes component.label_classes, "text-sm"
  end



  def test_track_classes_render_the_ks_progress_track_class
    assert_includes Keystone::Ui::ProgressComponent::TRACK_CLASSES, "ks-progress-track"
  end

  def test_track_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::ProgressComponent::TRACK_CLASSES
  end

  def test_bar_classes_render_the_ks_progress_bar_class
    assert_includes Keystone::Ui::ProgressComponent::BAR_CLASSES, "ks-progress-bar"
  end

  def test_bar_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::ProgressComponent::BAR_CLASSES
  end

  def test_label_classes_render_the_ks_meter_label_class
    assert_includes Keystone::Ui::ProgressComponent::LABEL_CLASSES, "ks-meter-label"
  end

  def test_label_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::ProgressComponent::LABEL_CLASSES
  end

  def test_a_thin_meter_draws_its_track_four_pixels_tall
    component = Keystone::Ui::ProgressComponent.new(value: 1, max: 4, thin: true)

    assert_equal %w[ks-progress-track w-full h-1 overflow-hidden], component.track_classes.split
  end

  def test_a_meter_given_a_tone_fills_its_bar_with_that_tones_colour
    component = Keystone::Ui::ProgressComponent.new(value: 1, max: 4, tone: :blue)

    assert_equal %w[ks-progress-bar h-full transition-all ks-fill-blue], component.bar_classes.split
  end
end
