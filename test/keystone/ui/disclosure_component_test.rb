# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::DisclosureComponentTest < Minitest::Test
  def test_is_closed_by_default
    refute Keystone::Ui::DisclosureComponent.new.open?
  end

  def test_can_be_opened_by_default
    assert Keystone::Ui::DisclosureComponent.new(open: true).open?
  end
end
