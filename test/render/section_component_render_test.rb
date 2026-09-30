# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::SectionComponentRenderTest < ViewComponent::TestCase
  def test_given_a_menu_shows_its_items_in_an_action_menu_in_the_header
    page = render_inline(Keystone::Ui::SectionComponent.new(title: "Spring lawn package",
      menu: [ { label: "Edit", href: "/offers/1/edit" }, { label: "Delete", href: "/offers/1", method: :delete } ])) { "" }

    assert_equal [ "Edit", "Delete" ], page.css(".ks-section-header [data-dropdown-target=menu] .ks-menu-option").map { |item| item.text.strip }
  end
end
