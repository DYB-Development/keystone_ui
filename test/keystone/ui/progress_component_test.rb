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


  def test_bar_classes_use_accent_fill
    component = Keystone::Ui::ProgressComponent.new(value: 3, max: 5)

    assert_includes component.bar_classes, "bg-accent-500"
  end

  def test_label_classes_render_a_small_caption
    component = Keystone::Ui::ProgressComponent.new(value: 3, max: 5, label: "Question 3 of 5")

    assert_includes component.label_classes, "text-sm"
  end


  def test_label_is_lightened_in_dark_mode
    component = Keystone::Ui::ProgressComponent.new(value: 1, max: 2, label: "Upload")

    assert_includes component.label_classes, "dark:text-surface-300"
  end

  def test_track_classes_render_the_ks_progress_track_class
    assert_includes Keystone::Ui::ProgressComponent::TRACK_CLASSES, "ks-progress-track"
  end

  def test_track_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::ProgressComponent::TRACK_CLASSES
  end
end
