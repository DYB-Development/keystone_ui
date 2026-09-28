# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::BucketComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_percent_is_the_share_of_the_goal_reached
    component = Keystone::Ui::BucketComponent.new(goal: 30_000, actual: 9_000)

    assert_equal 30, component.percent
  end

  def test_zero_goal_yields_zero_percent
    component = Keystone::Ui::BucketComponent.new(goal: 0, actual: 50)

    assert_equal 0, component.percent
  end

  def test_fill_stops_at_full_when_over_the_goal
    component = Keystone::Ui::BucketComponent.new(goal: 10_000, actual: 12_000)

    assert_equal 100, component.fill_percent
  end

  def test_fill_uses_the_accent_colour_at_or_under_the_goal
    component = Keystone::Ui::BucketComponent.new(goal: 10_000, actual: 10_000)

    assert_includes component.fill_classes, "bg-accent-500"
  end

  def test_fill_uses_the_success_colour_over_the_goal_by_default
    component = Keystone::Ui::BucketComponent.new(goal: 10_000, actual: 12_000)

    assert_includes component.fill_classes, "bg-green-500"
  end

  def test_fill_uses_the_warning_colour_over_the_goal_when_asked
    component = Keystone::Ui::BucketComponent.new(goal: 10_000, actual: 12_000, over: :warning)

    assert_includes component.fill_classes, "bg-amber-500"
  end

  def test_exposes_an_optional_label
    component = Keystone::Ui::BucketComponent.new(goal: 30_000, actual: 9_000, label: "Q1")

    assert_equal "Q1", component.label
  end

  def test_unknown_over_colour_raises_even_under_the_goal
    assert_raises(KeyError) do
      Keystone::Ui::BucketComponent.new(goal: 10_000, actual: 1, over: :sucess)
    end
  end

  def test_refuses_a_goal_that_is_not_a_number
    assert_raises(ArgumentError) do
      Keystone::Ui::BucketComponent.new(goal: "30,000", actual: 9_000)
    end
  end

  def test_container_classes_render_the_ks_bucket_class
    assert_includes Keystone::Ui::BucketComponent::CONTAINER_CLASSES, "ks-bucket"
  end

  def test_container_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::BucketComponent::CONTAINER_CLASSES
  end

  def test_label_classes_render_the_ks_bucket_label_class
    assert_includes Keystone::Ui::BucketComponent::LABEL_CLASSES, "ks-bucket-label"
  end

  def test_label_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::BucketComponent::LABEL_CLASSES
  end

  def test_goal_classes_render_the_ks_bucket_goal_class
    assert_includes Keystone::Ui::BucketComponent::GOAL_CLASSES, "ks-bucket-goal"
  end

  def test_goal_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::BucketComponent::GOAL_CLASSES
  end

  def test_tank_classes_render_the_ks_bucket_tank_class
    assert_includes Keystone::Ui::BucketComponent::TANK_CLASSES, "ks-bucket-tank"
  end
end
