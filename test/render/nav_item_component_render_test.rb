# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::NavItemComponentRenderTest < ViewComponent::TestCase
  def test_shows_its_count_in_a_badge_after_its_label
    page = render_inline(Keystone::Ui::NavItemComponent.new(label: "Questions", href: "/questions", count: 3))

    assert_equal "3", page.css("a.ks-nav-item .ks-badge").text.strip
  end
end
