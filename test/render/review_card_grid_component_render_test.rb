# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ReviewCardGridComponentRenderTest < ViewComponent::TestCase
  def test_sets_its_cards_three_across_on_a_desktop
    page = render_inline(Keystone::Ui::ReviewCardGridComponent.new) { "<article class=\"ks-card\">A</article>".html_safe }

    assert_includes page.at_css("div.grid")["class"].split, "lg:grid-cols-3"
  end
end
