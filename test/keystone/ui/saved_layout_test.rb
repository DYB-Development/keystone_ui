# frozen_string_literal: true

require "test_helper"
require_relative "../../../app/components/keystone/ui/column"
require_relative "../../../app/components/keystone/ui/saved_layout"

class Keystone::Ui::SavedLayoutTest < Minitest::Test
  def columns
    @columns ||= [
      Keystone::Ui::Column.new(:month, "Month", locked: true),
      Keystone::Ui::Column.new(:pipeline, "Pipeline", hideable: true),
      Keystone::Ui::Column.new(:outreach, "Outreach", hideable: true)
    ]
  end

  def test_hides_the_hideable_columns_its_value_names
    layout = Keystone::Ui::SavedLayout.new(columns: columns, value: { "hidden_columns" => [ "pipeline" ] }, default_hidden: [])

    assert_equal [ :month, :outreach ], layout.visible_columns.map(&:key)
  end

  def test_hides_the_default_hidden_columns_when_nothing_is_saved
    layout = Keystone::Ui::SavedLayout.new(columns: columns, value: nil, default_hidden: [ :outreach ])

    assert_equal [ :month, :pipeline ], layout.visible_columns.map(&:key)
  end

  def test_puts_its_hideable_columns_in_the_saved_order_and_leaves_the_others_in_place
    layout = Keystone::Ui::SavedLayout.new(columns: columns, value: { "column_order" => [ "outreach", "pipeline" ] }, default_hidden: [])

    assert_equal [ :month, :outreach, :pipeline ], layout.columns.map(&:key)
  end
end
