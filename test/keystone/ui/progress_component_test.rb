# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::ProgressComponentTest < Minitest::Test
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

  def test_track_classes_form_a_rounded_rail
    component = Keystone::Ui::ProgressComponent.new(value: 3, max: 5)

    assert_includes component.track_classes, "rounded-full"
  end

  def test_bar_classes_use_accent_fill
    component = Keystone::Ui::ProgressComponent.new(value: 3, max: 5)

    assert_includes component.bar_classes, "bg-accent-500"
  end

  def test_label_classes_render_a_small_caption
    component = Keystone::Ui::ProgressComponent.new(value: 3, max: 5, label: "Question 3 of 5")

    assert_includes component.label_classes, "text-sm"
  end
end
