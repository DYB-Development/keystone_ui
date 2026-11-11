# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::SectionComponentRenderTest < ViewComponent::TestCase
  def test_given_a_menu_shows_its_items_in_an_action_menu_in_the_header
    page = render_inline(Keystone::Ui::SectionComponent.new(title: "Spring lawn package",
      menu: [ { label: "Edit", href: "/offers/1/edit" }, { label: "Delete", href: "/offers/1", method: :delete } ])) { "" }

    assert_equal [ "Edit", "Delete" ], page.css(".ks-section-header [data-action-menu-target=menu] .ks-menu-option").map { |item| item.text.strip }
  end

  def test_given_an_action_and_a_menu_puts_the_action_in_the_same_last_element_of_the_header_as_the_menu
    page = render_inline(Keystone::Ui::SectionComponent.new(title: "Crew", action: { label: "Add", href: "/crew/new" },
      menu: [ { label: "Edit", href: "/crew/edit" } ])) { "" }

    actions = page.css(".ks-section-header > *").last

    assert_equal [ "Add", "Actions" ], [ actions.at_css(".ks-section-action")&.text&.strip, actions.at_css("[data-action-menu-target=button]")&.[]("aria-label") ]
  end
end
