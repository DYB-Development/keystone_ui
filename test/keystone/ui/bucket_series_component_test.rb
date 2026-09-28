# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::BucketSeriesComponentTest < Minitest::Test
  def test_builds_one_bucket_per_entry_with_its_own_goal
    component = Keystone::Ui::BucketSeriesComponent.new(buckets: [
      { label: "Leads", goal: 600, actual: 450 },
      { label: "Deals", goal: 40, actual: 12 }
    ])

    assert_equal [ 600, 40 ], component.bucket_components.map(&:goal)
  end

  def test_row_wraps_onto_more_lines_on_narrow_screens
    component = Keystone::Ui::BucketSeriesComponent.new(buckets: [])

    assert_includes component.row_classes, "flex-wrap"
  end

  def test_row_classes_render_the_ks_bucket_series_class
    assert_includes Keystone::Ui::BucketSeriesComponent::ROW_CLASSES, "ks-bucket-series"
  end
end
