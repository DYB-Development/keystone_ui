# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::GridComponentTest < Minitest::Test
  def test_defaults_to_grid_gap_4_grid_cols_1
    component = Keystone::Ui::GridComponent.new

    assert_equal "grid gap-4 grid-cols-1", component.classes
  end

  def test_builds_responsive_column_classes_for_multiple_breakpoints
    component = Keystone::Ui::GridComponent.new(cols: { default: 1, sm: 2, lg: 4 })

    assert_includes component.classes, "grid-cols-1"
    assert_includes component.classes, "sm:grid-cols-2"
    assert_includes component.classes, "lg:grid-cols-4"
  end

  def test_maps_each_gap_size_correctly
    assert_includes Keystone::Ui::GridComponent.new(gap: :sm).classes, "gap-3"
    assert_includes Keystone::Ui::GridComponent.new(gap: :md).classes, "gap-4"
    assert_includes Keystone::Ui::GridComponent.new(gap: :lg).classes, "gap-6"
    assert_includes Keystone::Ui::GridComponent.new(gap: :xl).classes, "gap-8"
  end

  def test_uses_split_gap_classes_when_gap_x_and_gap_y_are_provided
    component = Keystone::Ui::GridComponent.new(cols: { default: 1, sm: 6 }, gap_x: :lg, gap_y: :xl)

    assert_includes component.classes, "gap-x-6"
    assert_includes component.classes, "gap-y-8"
    refute_includes component.classes, "gap-4"
  end

  def test_uses_gap_x_only_when_gap_y_is_not_provided
    component = Keystone::Ui::GridComponent.new(gap_x: :md)

    assert_includes component.classes, "gap-x-4"
    refute_includes component.classes, "gap-y"
    refute_includes component.classes, "gap-4"
  end

  def test_uses_gap_y_only_when_gap_x_is_not_provided
    component = Keystone::Ui::GridComponent.new(gap_y: :lg)

    assert_includes component.classes, "gap-y-6"
    refute_includes component.classes, "gap-x"
    refute_includes component.classes, "gap-4"
  end

  def test_ignores_gap_when_gap_x_or_gap_y_is_provided
    component = Keystone::Ui::GridComponent.new(gap: :sm, gap_x: :lg, gap_y: :xl)

    assert_includes component.classes, "gap-x-6"
    assert_includes component.classes, "gap-y-8"
    refute_includes component.classes, "gap-3"
  end

  def test_defines_col_classes_with_static_class_strings_for_each_breakpoint
    col_classes = Keystone::Ui::GridComponent::COL_CLASSES

    assert_equal "grid-cols-1", col_classes[:default][1]
    assert_equal "grid-cols-12", col_classes[:default][12]
    assert_equal "sm:grid-cols-2", col_classes[:sm][2]
    assert_equal "md:grid-cols-6", col_classes[:md][6]
    assert_equal "lg:grid-cols-4", col_classes[:lg][4]
  end

  def test_raises_keyerror_for_unsupported_column_counts
    assert_raises(KeyError) { Keystone::Ui::GridComponent.new(cols: { default: 99 }).classes }
  end
end
