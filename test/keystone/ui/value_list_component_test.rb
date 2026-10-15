# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::ValueListComponentTest < Minitest::Test
  def test_places_values_beside_their_labels_or_at_the_end_of_each_row
    assert_equal [ "ks-value-list", "ks-value-list ks-value-list-end" ],
      %i[start end].map { |align| Keystone::Ui::ValueListComponent.new(rows: [], align: align).classes }
  end
end
