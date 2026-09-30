# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ActionMenuItemComponentRenderTest < ViewComponent::TestCase
  def test_an_item_that_opens_a_page_is_a_menu_link
    page = render_inline(Keystone::Ui::ActionMenuItemComponent.new(label: "Edit", href: "/offers/1/edit"))

    assert_equal [ [ "/offers/1/edit", "Edit" ] ], page.css("a.ks-menu-option").map { |link| [ link["href"], link.text.strip ] }
  end
end
