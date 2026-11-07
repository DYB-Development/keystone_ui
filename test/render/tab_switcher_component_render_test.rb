# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::TabSwitcherComponentRenderTest < ViewComponent::TestCase
  LINK_TABS = [
    { label: "Offer", href: "/offers/6?tab=offer" },
    { label: "Value", href: "/offers/6?tab=value", current: true }
  ].freeze

  def test_link_tabs_are_drawn_as_links_to_their_addresses
    page = render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: LINK_TABS))

    assert_equal [ [ "Offer", "/offers/6?tab=offer" ], [ "Value", "/offers/6?tab=value" ] ],
      page.css("a.ks-tab").map { |link| [ link.text.strip, link["href"] ] }
  end
end
