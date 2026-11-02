# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::MobileActionsComponentRenderTest < ViewComponent::TestCase
  def test_opens_scrolls_and_closes_its_items_the_way_an_action_menu_does
    page = render_inline(Keystone::Ui::MobileActionsComponent.new) { "<a href=\"/edit\">Edit</a>".html_safe }
    menu = page.at_css("[data-controller=action-menu]")

    assert_equal [ "scroll@window->action-menu#follow resize@window->action-menu#close", "click->action-menu#toggle pointerup@window->action-menu#hide", [ "/edit" ] ],
      [ menu&.[]("data-action"), menu&.at_css("button[data-action-menu-target=button]")&.[]("data-action"), page.css("[data-controller=action-menu] [data-action-menu-target=menu] a").map { |link| link["href"] } ]
  end
end
