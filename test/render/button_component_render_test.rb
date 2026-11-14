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

  def test_a_full_width_button_sending_a_request_has_a_form_as_wide_as_its_row
    page = render_inline(Keystone::Ui::ButtonComponent.new(label: "Answer", href: "/answers", method: :post, full_width: true))

    assert_equal "w-full", page.at_css("form")["class"]
  end

  def test_a_button_sending_a_request_with_a_confirmation_asks_it_before_sending
    page = render_inline(Keystone::Ui::ButtonComponent.new(label: "Stop", href: "/runs/1/stop", method: :post, confirm: "Stop the run?"))

    assert_equal "Stop the run?", page.at_css("form")&.[]("data-turbo-confirm")
  end

  def test_a_link_button_with_a_confirmation_asks_it_before_following
    page = render_inline(Keystone::Ui::ButtonComponent.new(label: "Open", href: "/runs/1", confirm: "Open the run?"))

    assert_equal "Open the run?", page.at_css("a")&.[]("data-turbo-confirm")
  end
end
