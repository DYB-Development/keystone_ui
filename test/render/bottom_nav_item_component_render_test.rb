# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::BottomNavItemComponentRenderTest < ViewComponent::TestCase
  ICON = %(<svg viewBox="0 0 24 24"></svg>)

  def test_shows_its_count_in_a_badge_over_its_icon
    page = render_inline(Keystone::Ui::BottomNavItemComponent.new(label: "Questions", href: "/questions", icon: ICON, count: 3))

    assert_equal "3", page.css("a.ks-bottom-nav-item .ks-badge").text.strip
  end
end
