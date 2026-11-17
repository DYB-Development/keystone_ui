# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::NavDropdownComponentRenderTest < ViewComponent::TestCase
  def test_cuts_a_long_title_short_inside_the_trigger
    page = render_inline(Keystone::Ui::NavDropdownComponent.new(title: "Approve the copy for the spring email campaign before Friday", area: "Console")) { "" }

    assert_equal "min-w-0 truncate", page.at_css("button.ks-nav-dropdown-trigger > span")&.[]("class")
  end
end
