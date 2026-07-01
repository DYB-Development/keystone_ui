# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::DisclosureComponentTest < Minitest::Test
  def test_is_closed_by_default
    refute Keystone::Ui::DisclosureComponent.new.open?
  end
end
