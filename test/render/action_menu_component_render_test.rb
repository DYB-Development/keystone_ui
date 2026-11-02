# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ActionMenuComponentRenderTest < ViewComponent::TestCase
  def test_shows_its_items_in_a_dropdown_opened_by_an_actions_button
    page = render_inline(Keystone::Ui::ActionMenuComponent.new) { "<a href=\"/edit\">Edit</a>".html_safe }

    assert_equal [ "/edit" ], page.css("[data-controller=action-menu] button[aria-label=Actions] ~ [data-action-menu-target=menu] a").map { |link| link["href"] }
  end

  def test_an_open_menu_moves_with_the_page_as_it_scrolls_and_closes_when_the_screen_resizes
    page = render_inline(Keystone::Ui::ActionMenuComponent.new) { "Edit" }

    assert_equal "scroll@window->action-menu#follow resize@window->action-menu#close", page.at_css("[data-controller=action-menu]")["data-action"]
  end

  def test_a_view_draws_an_action_menu_of_items_with_the_ui_action_menu_helpers
    page = render_in_view_context do
      ui_action_menu do
        ui_action_menu_item(label: "Edit", href: "/offers/1/edit") + ui_action_menu_item(label: "Delete", href: "/offers/1", method: :delete)
      end
    end

    assert_equal [ "Edit", "Delete" ], page.css("[data-action-menu-target=menu] .ks-menu-option").map { |item| item.text.strip }
  end
end
