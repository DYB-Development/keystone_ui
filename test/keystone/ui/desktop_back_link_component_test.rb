# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::DesktopBackLinkComponentTest < Minitest::Test
  def test_exposes_url
    component = Keystone::Ui::DesktopBackLinkComponent.new(url: "/invoices")

    assert_equal "/invoices", component.instance_variable_get(:@url)
  end
end
