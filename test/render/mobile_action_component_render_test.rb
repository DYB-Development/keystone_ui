# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::MobileActionComponentRenderTest < ViewComponent::TestCase
  def test_links_to_the_address_a_page_header_publishes
    page = render_after_page_header(title: "Events", action_url: "/events/new", action_label: "Create")

    assert_equal "/events/new", top_bar_link(page)&.[]("href")
  end

  def test_names_the_link_with_the_label_a_page_header_publishes
    page = render_after_page_header(title: "Events", action_url: "/events/new", action_label: "Create")

    assert_equal "Create", top_bar_link(page)&.[]("aria-label")
  end

  def test_given_no_published_action_draws_nothing
    page = render_inline(Keystone::Ui::MobileActionComponent.new)

    assert_empty page.css("a")
  end

  def test_hides_from_the_width_where_the_page_header_shows
    page = render_after_page_header(title: "Events", action_url: "/events/new")

    assert_includes top_bar_link(page)&.[]("class").to_s.split, "sm:hidden"
  end

  def test_hides_inside_a_hotwire_native_web_view
    page = render_after_page_header(title: "Events", action_url: "/events/new")

    assert_includes top_bar_link(page)&.[]("class").to_s.split, "hotwire-native:hidden"
  end

  def test_hides_when_the_page_is_printed
    page = render_after_page_header(title: "Events", action_url: "/events/new")

    assert_includes top_bar_link(page)&.[]("class").to_s.split, "print:hidden"
  end

  def test_colours_the_link_like_the_action_menu_button_beside_it
    page = render_after_page_header(title: "Events", action_url: "/events/new")

    assert_includes top_bar_link(page)&.[]("class").to_s.split, Keystone::Ui::MobileActionsComponent::BUTTON_CLASSES
  end

  private

  def render_after_page_header(**header)
    render_in_view_context do
      safe_join([ render(Keystone::Ui::PageHeaderComponent.new(**header)), render(Keystone::Ui::MobileActionComponent.new) ])
    end
  end

  def top_bar_link(page)
    page.css("a").find { |link| !link.ancestors(".ks-page-header").any? }
  end
end
