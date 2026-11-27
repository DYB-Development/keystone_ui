# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::PanelComponentRenderTest < ViewComponent::TestCase
  def test_draws_its_title_as_a_heading_above_its_content
    page = render_inline(Keystone::Ui::PanelComponent.new(title: "Same value per dollar")) { "The working" }

    assert_equal "Same value per dollar", page.at_css(".ks-panel h3")&.text&.strip
  end
end
