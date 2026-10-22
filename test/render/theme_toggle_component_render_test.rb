# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ThemeToggleComponentRenderTest < ViewComponent::TestCase
  def test_is_one_button
    page = render_inline(Keystone::Ui::ThemeToggleComponent.new)

    assert_equal 1, page.css("button").size
  end
end
