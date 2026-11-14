# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::BottomActionComponentRenderTest < ViewComponent::TestCase
  def test_labels_its_button_with_the_label_a_page_header_publishes
    page = render_after_page_header(title: "Events", action_url: "/events/new", action_label: "Create")

    assert_equal "Create", bottom_bar(page)&.at_css("a")&.text&.strip
  end

  def test_links_its_button_to_the_address_a_page_header_publishes
    page = render_after_page_header(title: "Events", action_url: "/events/new", action_label: "Create")

    assert_equal "/events/new", bottom_bar(page)&.at_css("a")&.[]("href")
  end

  def test_draws_its_button_across_the_full_width_of_the_screen
    page = render_after_page_header(title: "Events", action_url: "/events/new", action_label: "Create")

    assert_includes bottom_bar(page)&.at_css("a")&.[]("class").to_s.split, "w-full"
  end


  def test_given_a_published_action_method_sends_that_method_to_the_action_address
    page = render_after_page_header(title: "Run", action_url: "/runs/1/stop", action_label: "Stop", action_method: :post)

    assert_equal "/runs/1/stop", bottom_bar(page)&.at_css("form[method='post']")&.[]("action")
  end


  def test_given_no_published_action_draws_nothing
    page = render_inline(Keystone::Ui::BottomActionComponent.new)

    assert_nil bottom_bar(page)
  end


  def test_hides_from_640_pixels_wide_as_the_top_bars_action_does
    page = render_after_page_header(title: "Events", action_url: "/events/new", action_label: "Create")

    assert_includes bottom_bar(page)&.[]("class").to_s.split, "sm:hidden"
  end


  def test_hides_inside_a_hotwire_native_web_view
    page = render_after_page_header(title: "Events", action_url: "/events/new", action_label: "Create")

    assert_includes bottom_bar(page)&.[]("class").to_s.split, "hotwire-native:hidden"
  end


  def test_hides_when_the_page_is_printed
    page = render_after_page_header(title: "Events", action_url: "/events/new", action_label: "Create")

    assert_includes bottom_bar(page)&.[]("class").to_s.split, "print:hidden"
  end


  def test_keeps_a_copy_of_the_bar_in_the_pages_flow_so_the_last_content_scrolls_clear_of_it
    page = render_after_page_header(title: "Events", action_url: "/events/new", action_label: "Create")

    assert_includes bar_copy(page)&.[]("class").to_s.split, "!static"
  end


  def test_cannot_be_seen_as_a_second_bar
    page = render_after_page_header(title: "Events", action_url: "/events/new", action_label: "Create")

    assert_includes bar_copy(page)&.[]("class").to_s.split, "invisible"
  end


  def test_its_copy_in_the_pages_flow_cannot_be_reached_or_pressed
    page = render_after_page_header(title: "Events", action_url: "/events/new", action_label: "Create")

    assert spacer(page)&.has_attribute?("inert")
  end


  def test_its_copy_in_the_pages_flow_also_keeps_room_for_the_bottom_tab_bar_when_the_page_has_one
    page = render_after_page_header(title: "Events", action_url: "/events/new", action_label: "Create")

    assert spacer(page)&.css("div")&.any? { |block| ([ "h-(--ks-bottom-nav-height)", "[body:has(.ks-bottom-nav)_&]:block" ] - block[:class].to_s.split).empty? }
  end


  def test_asks_the_confirmation_a_page_header_publishes_before_sending_the_action
    page = render_after_page_header(title: "Run", action_url: "/runs/1/stop", action_label: "Stop", action_method: :post, action_confirm: "Stop the run?")

    assert_equal "Stop the run?", bottom_bar(page)&.at_css("form")&.[]("data-turbo-confirm")
  end

  private

  def render_after_page_header(**header)
    render_in_view_context do
      safe_join([ render(Keystone::Ui::PageHeaderComponent.new(**header)), render(Keystone::Ui::BottomActionComponent.new) ])
    end
  end

  def bottom_bar(page)
    page.at_css(".ks-bottom-action")
  end

  def spacer(page)
    page.at_css("[data-bottom-action-spacer]")
  end

  def bar_copy(page)
    spacer(page)&.at_css(".ks-bottom-action")
  end
end
