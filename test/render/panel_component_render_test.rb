# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::PanelComponentRenderTest < ViewComponent::TestCase
  def test_draws_its_title_as_a_heading_above_its_content
    page = render_inline(Keystone::Ui::PanelComponent.new(title: "Same value per dollar")) { "The working" }

    assert_equal "Same value per dollar", page.at_css(".ks-panel h3")&.text&.strip
  end

  def test_a_selected_panel_marks_its_title_with_its_selected_marker
    page = render_inline(Keystone::Ui::PanelComponent.new(title: "Same value per dollar", selected: true, selected_marker: "(in use)")) { "The working" }

    assert_equal "Same value per dollar (in use)", page.at_css(".ks-panel h3")&.text&.squish
  end

  def test_a_panel_that_is_not_selected_leaves_its_selected_marker_out
    page = render_inline(Keystone::Ui::PanelComponent.new(title: "Same value per dollar", selected_marker: "(in use)")) { "The working" }

    assert_equal "Same value per dollar", page.at_css(".ks-panel h3")&.text&.squish
  end

  def test_draws_its_aside_at_the_end_of_its_title_line
    page = render_inline(Keystone::Ui::PanelComponent.new(title: "Same value per dollar", aside: "$3,000")) { "The working" }

    assert_equal "$3,000", page.at_css(".ks-panel h3 + .ks-heading-note")&.text&.strip
  end
end
