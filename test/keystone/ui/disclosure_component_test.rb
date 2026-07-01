# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::DisclosureComponentTest < Minitest::Test
  def test_is_closed_by_default
    refute Keystone::Ui::DisclosureComponent.new.open?
  end

  def test_can_be_opened_by_default
    assert Keystone::Ui::DisclosureComponent.new(open: true).open?
  end

  def test_summary_is_a_clickable_row_with_hidden_native_marker
    classes = Keystone::Ui::DisclosureComponent.new.summary_classes

    assert_includes classes, "cursor-pointer"
    assert_includes classes, "list-none"
  end
end
