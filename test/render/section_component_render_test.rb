# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::SectionComponentRenderTest < ViewComponent::TestCase
  def test_given_a_menu_shows_its_items_in_an_action_menu_in_the_header
    page = render_inline(Keystone::Ui::SectionComponent.new(title: "Spring lawn package",
      menu: [ { label: "Edit", href: "/offers/1/edit" }, { label: "Delete", href: "/offers/1", method: :delete } ])) { "" }

    assert_equal [ "Edit", "Delete" ], page.css(".ks-section-header [data-action-menu-target=menu] .ks-menu-option").map { |item| item.text.strip }
  end

  def test_given_an_action_and_a_menu_puts_the_action_in_the_same_last_element_of_the_header_as_the_menu
    page = render_inline(Keystone::Ui::SectionComponent.new(title: "Crew", action: { label: "Add", href: "/crew/new" },
      menu: [ { label: "Edit", href: "/crew/edit" } ])) { "" }

    actions = page.css(".ks-section-header > *").last

    assert_equal [ "Add", "Actions" ], [ actions.at_css(".ks-section-action")&.text&.strip, actions.at_css("[data-action-menu-target=button]")&.[]("aria-label") ]
  end

  def test_given_no_action_and_no_menu_draws_no_actions_row
    page = render_inline(Keystone::Ui::SectionComponent.new(title: "Crew")) { "" }

    assert_equal 1, page.css(".ks-section-header > *").size
  end

  def test_lays_out_its_actions_side_by_side_in_one_row_that_does_not_shrink
    page = render_inline(Keystone::Ui::SectionComponent.new(title: "Crew", action: { label: "Add", href: "/crew/new" },
      menu: [ { label: "Edit", href: "/crew/edit" } ])) { "" }

    assert_equal "flex items-center shrink-0 ks-grid-gap-sm", page.css(".ks-section-header > *").last["class"]
  end

  def test_given_an_aside_shows_it_in_the_header_after_the_title
    page = render_inline(Keystone::Ui::SectionComponent.new(title: "Inbox")) do |section|
      section.with_aside { "sorted by expiry" }
      ""
    end

    assert_equal "sorted by expiry", page.css(".ks-section-header > *")[1]&.text&.strip
  end

  def test_refuses_an_aside_given_with_no_title
    error = assert_raises(ArgumentError) do
      render_inline(Keystone::Ui::SectionComponent.new) do |section|
        section.with_aside { "sorted by expiry" }
        ""
      end
    end

    assert_includes error.message, "aside needs a title"
  end

  def test_never_breaks_an_aside_in_the_middle_of_a_word
    assert_includes aside_classes(render_with_aside), "wrap-normal"
  end

  def test_keeps_an_aside_at_its_full_width_beside_a_long_title
    assert_includes aside_classes(render_with_aside), "sm:shrink-0"
  end

  def test_lets_a_long_title_wrap_beside_an_aside
    assert_equal "min-w-0", render_with_aside.css(".ks-section-header > *")[0]["class"]
  end

  def test_draws_an_aside_in_the_small_muted_text_of_a_heading_note
    assert_includes aside_classes(render_with_aside), "ks-heading-note"
  end

  def test_pushes_an_aside_to_the_right_end_of_the_header
    assert_includes aside_classes(render_with_aside(action: { label: "Add", href: "/inbox/new" })), "ml-auto"
  end

  def test_spaces_the_parts_of_a_header_with_an_aside_apart
    assert_includes render_with_aside.at_css(".ks-section-header")["class"].split, "ks-grid-gap-sm"
  end

  def test_lets_a_header_with_an_aside_wrap_onto_a_second_line_on_a_phone
    assert_includes render_with_aside.at_css(".ks-section-header")["class"].split, "max-sm:flex-wrap"
  end

  def test_gives_an_aside_the_full_width_of_the_header_on_a_phone
    assert_includes aside_classes(render_with_aside), "max-sm:basis-full"
  end

  def test_moves_an_aside_below_the_title_and_actions_on_a_phone
    assert_includes aside_classes(render_with_aside(action: { label: "Add", href: "/inbox/new" })), "max-sm:order-last"
  end

  private

  def render_with_aside(**args)
    render_inline(Keystone::Ui::SectionComponent.new(title: "Inbox", **args)) do |section|
      section.with_aside { "sorted by expiry" }
      ""
    end
  end

  def aside_classes(page)
    page.css(".ks-section-header > *")[1]["class"].to_s.split
  end
end
