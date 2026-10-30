# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ButtonComponentRenderTest < ViewComponent::TestCase
  def test_a_button_given_a_post_request_sends_it_from_its_own_form
    page = render_inline(Keystone::Ui::ButtonComponent.new(label: "Start", href: "/games/1/start", method: :post))

    assert_equal [ [ "/games/1/start", "post", "Start" ] ],
      page.css("form").map { |form| [ form["action"], form["method"], form.at_css("button.ks-button")&.text&.strip ] }
  end

  def test_a_button_given_a_delete_request_sends_its_method
    page = render_inline(Keystone::Ui::ButtonComponent.new(label: "Remove", href: "/games/1", method: :delete))

    assert_equal "delete", page.at_css("form input[name=_method]")&.[]("value")
  end
end
