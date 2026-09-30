# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ActionMenuItemComponentRenderTest < ViewComponent::TestCase
  def test_an_item_that_opens_a_page_is_a_menu_link
    page = render_inline(Keystone::Ui::ActionMenuItemComponent.new(label: "Edit", href: "/offers/1/edit"))

    assert_equal [ [ "/offers/1/edit", "Edit" ] ], page.css("a.ks-menu-option").map { |link| [ link["href"], link.text.strip ] }
  end
  def test_an_item_that_changes_something_is_a_menu_button_sending_its_method
    page = render_inline(Keystone::Ui::ActionMenuItemComponent.new(label: "Delete", href: "/offers/1", method: :delete))

    assert_equal [ [ "/offers/1", "delete", "Delete" ] ],
      page.css("form").map { |form| [ form["action"], form.at_css("input[name=_method]")&.[]("value"), form.at_css("button.ks-menu-option")&.text&.strip ] }
  end
  def test_an_item_that_deletes_asks_before_it_sends
    page = render_inline(Keystone::Ui::ActionMenuItemComponent.new(label: "Remove", href: "/offers/1/names/2", method: :delete))

    assert_equal "Remove this? This cannot be undone.", page.at_css("form")["data-turbo-confirm"]
  end
  def test_an_item_asks_the_question_it_is_given
    page = render_inline(Keystone::Ui::ActionMenuItemComponent.new(label: "Make a new version", href: "/offers/1/versions", method: :post,
      confirm: "Make a new version of this offer?"))

    assert_equal "Make a new version of this offer?", page.at_css("form")["data-turbo-confirm"]
  end
end
