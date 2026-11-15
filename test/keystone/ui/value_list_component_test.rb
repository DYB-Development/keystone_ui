# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::ValueListComponentTest < Minitest::Test
  def test_places_values_beside_their_labels_or_at_the_end_of_each_row
    assert_equal [ "ks-value-list", "ks-value-list ks-value-list-end" ],
      %i[start end].map { |align| Keystone::Ui::ValueListComponent.new(rows: [], align: align).classes }
  end

  def test_in_columns_lays_the_pairs_in_one_column_on_a_phone
    assert_includes Keystone::Ui::ValueListComponent.new(rows: [], columns: true).classes.split, "grid-cols-1"
  end

  def test_in_columns_lays_the_pairs_in_two_columns_on_a_wide_screen
    assert_includes Keystone::Ui::ValueListComponent.new(rows: [], columns: true).classes.split, "sm:grid-cols-2"
  end

  def test_in_columns_lets_a_long_value_shrink_its_pair_to_the_column_width
    assert_includes Keystone::Ui::ValueListComponent.new(rows: [], columns: true).row_classes({}).split, "min-w-0"
  end

  def test_in_columns_spaces_the_pairs_apart_by_the_small_grid_gap
    assert_includes Keystone::Ui::ValueListComponent.new(rows: [], columns: true).classes.split, "ks-grid-gap-sm"
  end
end
