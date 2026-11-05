# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::EmptyStateComponentRenderTest < ViewComponent::TestCase
  def test_shows_its_title_as_a_heading
    page = render_inline(Keystone::Ui::EmptyStateComponent.new(title: "No reports yet"))

    assert_equal "No reports yet", page.css("h2.ks-heading-sm").text.strip
  end

  def test_shows_its_message_in_muted_text_under_the_title
    page = render_inline(Keystone::Ui::EmptyStateComponent.new(title: "No reports yet", message: "Reports appear here once the team shares one."))

    assert_equal "Reports appear here once the team shares one.", page.css("p.ks-paragraph.ks-tone-muted").text.strip
  end

  def test_leaves_out_the_message_when_none_is_given
    page = render_inline(Keystone::Ui::EmptyStateComponent.new(title: "No reports yet"))

    assert_empty page.css("p.ks-paragraph")
  end

  def test_shows_its_action_as_a_secondary_button_link
    page = render_inline(Keystone::Ui::EmptyStateComponent.new(title: "No forms started", action: { label: "Start", href: "/forms/new" }))

    assert_equal "/forms/new", page.css("a.ks-button.ks-button-secondary").attr("href").value
  end
end
