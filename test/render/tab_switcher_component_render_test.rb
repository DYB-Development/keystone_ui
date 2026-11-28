# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::TabSwitcherComponentRenderTest < ViewComponent::TestCase
  LINK_TABS = [
    { label: "Offer", href: "/offers/6?tab=offer" },
    { label: "Value", href: "/offers/6?tab=value", current: true }
  ].freeze

  def test_link_tabs_are_drawn_as_links_to_their_addresses
    page = render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: LINK_TABS))

    assert_equal [ [ "Offer", "/offers/6?tab=offer" ], [ "Value", "/offers/6?tab=value" ] ],
      page.css("a.ks-tab").map { |link| [ link.text.strip, link["href"] ] }
  end

  def test_only_the_chosen_link_tab_is_drawn_active_and_announced_as_the_current_page
    page = render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: LINK_TABS))

    assert_equal [ [ "Value", "page" ] ],
      page.css("a.ks-tab-active").map { |link| [ link.text.strip, link["aria-current"] ] }
  end

  def test_only_the_chosen_link_tab_carries_the_mark_the_active_tab_style_reads
    page = render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: LINK_TABS))

    assert_equal [ "Value" ], page.css("a.ks-tab[data-active]").map { |link| link.text.strip }
  end

  def test_link_tabs_wrap_onto_a_new_line_when_they_do_not_fit_the_width
    page = render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: LINK_TABS))

    assert_includes page.at_css("nav.ks-tab-bar")["class"].split, "flex-wrap"
  end

  def test_tabs_given_as_plain_labels_are_still_buttons_the_browser_switches_between
    page = render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: [ "One", "Two" ]))

    assert_equal [ [ "One", "click->tab-switcher#select" ], [ "Two", "click->tab-switcher#select" ] ],
      page.css("[data-controller=tab-switcher] button.ks-tab").map { |tab| [ tab.text.strip, tab["data-action"] ] }
  end

  def test_from_sm_up_a_summary_is_drawn_above_the_tab_row_and_the_panel
    assert_equal %w[summary tabs panel], drawn_order(render_with_summary, "sm")
  end

  def test_below_sm_the_tab_row_is_drawn_above_the_summary_and_the_panel
    assert_equal %w[tabs summary panel], drawn_order(render_with_summary, "max-sm")
  end

  def test_a_summary_the_tab_row_and_the_panel_are_a_column_only_below_sm_so_their_margins_overlap_from_sm_up
    wrapper = render_with_summary.children.find(&:element?)

    assert_equal %w[max-sm:flex max-sm:flex-col], wrapper["class"].to_s.split & %w[flex flex-col max-sm:flex max-sm:flex-col]
  end

  def test_below_sm_the_summary_drops_its_first_part_top_margin_so_the_tab_row_margin_alone_spaces_it
    assert_includes summary_wrapper(render_with_summary)["class"].split, "max-sm:[&>:first-child]:mt-0"
  end

  def test_below_sm_the_summary_drops_its_last_part_bottom_margin_so_the_panel_margin_alone_spaces_them
    assert_includes summary_wrapper(render_with_summary)["class"].split, "max-sm:[&>:last-child]:mb-0"
  end

  def test_with_no_summary_the_tab_row_and_panel_are_drawn_with_no_column_around_them
    page = render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: LINK_TABS)) { "Value panel" }

    assert_equal "nav", page.children.find(&:element?).name
  end

  def test_below_sm_no_tab_label_wraps_onto_a_second_line_or_is_squeezed_narrower
    page = render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: LINK_TABS))

    assert_equal [ %w[max-sm:shrink-0 max-sm:whitespace-nowrap] ] * 2,
      page.css("a.ks-tab").map { |link| link["class"].split & %w[max-sm:shrink-0 max-sm:whitespace-nowrap] }
  end

  def test_from_sm_up_link_tabs_wrap_and_are_centred
    page = render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: LINK_TABS))

    assert_equal %w[flex-wrap justify-center], page.at_css("nav.ks-tab-bar")["class"].split.grep_v(/\Amax-sm:/) & %w[flex-wrap justify-center flex-nowrap justify-start]
  end

  def test_below_sm_tabs_given_as_plain_labels_are_also_drawn_above_the_summary_and_the_panel
    page = render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: [ "One", "Two" ])) do |switcher|
      switcher.with_summary { "Stat cards" }
      "Value panel"
    end

    assert_equal %w[tabs summary panel], drawn_order(page, "max-sm")
  end

  def test_following_a_link_tab_replaces_the_current_history_entry
    page = render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: LINK_TABS))

    assert_equal [ "replace", "replace" ], page.css("a.ks-tab").map { |link| link["data-turbo-action"] }
  end

  def test_a_link_tab_given_a_count_draws_it_in_an_info_badge_after_its_label
    page = render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: [ { label: "Approvals", href: "/inbox?filter=approvals", count: 4 } ]))

    assert_equal "4", page.at_css("a.ks-tab .ks-badge.ks-badge-info")&.text&.strip
  end

  def test_a_link_tab_with_a_count_of_zero_draws_no_badge_as_a_navigation_item_does
    page = render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: [ { label: "Input", href: "/inbox?filter=input", count: 0 } ]))

    assert_nil page.at_css("a.ks-tab .ks-badge")
  end

  def test_a_link_tab_set_to_show_a_zero_count_draws_it_after_its_label
    page = render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: [ { label: "Input", href: "/inbox?filter=input", count: 0, show_zero: true } ], shape: :pills))

    assert_equal "0", page.at_css("a.ks-tab .ks-tab-count")&.text
  end

  def test_in_a_tab_row_aligned_to_the_start_the_chosen_link_tab_is_still_marked_as_the_current_tab
    page = render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: LINK_TABS, align: :start))

    assert_equal [ "Value" ], page.css("a.ks-tab.ks-tab-active[data-active][aria-current=page]").map { |link| link.text.strip }
  end

  def test_in_a_shaped_tab_row_no_tab_carries_its_own_text_size_so_the_shape_sets_it
    page = render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: LINK_TABS, shape: :pills))

    assert_equal [ false, false ], page.css("a.ks-tab").map { |link| link["class"].split.include?("text-sm") }
  end

  def test_in_a_shaped_tab_row_a_count_is_drawn_as_plain_text_after_the_label_and_not_as_a_badge
    page = render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: [ { label: "Approvals", href: "/inbox?filter=approvals", count: 4 } ], shape: :pills))

    assert_equal [ "Approvals 4", [ "4" ], 0 ],
      [ page.at_css("a.ks-tab").text.strip, page.css("a.ks-tab span.ks-tab-count").map(&:text), page.css("a.ks-tab .ks-badge").size ]
  end

  def test_with_a_panel_per_tab_only_the_first_panel_is_shown_when_the_page_loads
    page = render_with_panels

    assert_equal [ false, true ], page.css("[data-tab-switcher-target=panel]").map { |panel| panel.key?("hidden") }
  end

  def test_with_a_panel_per_tab_the_fields_of_each_hidden_panel_are_disabled_so_they_neither_block_nor_join_the_form
    page = render_with_panels

    assert_equal [ false, true ], page.css("fieldset[data-tab-switcher-target=panel]").map { |panel| panel.key?("disabled") }
  end

  def test_with_a_panel_per_tab_each_panel_may_shrink_below_the_width_of_its_content_on_a_phone
    page = render_with_panels

    assert_equal [ true, true ], page.css("fieldset[data-tab-switcher-target=panel]").map { |panel| panel["class"].to_s.split.include?("min-w-0") }
  end

  def test_link_tabs_given_an_id_put_it_on_the_tab_row_so_a_turbo_stream_can_replace_the_row
    page = render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: LINK_TABS, id: "offer_tabs"))

    assert_equal "offer_tabs", page.at_css("nav.ks-tab-bar")["id"]
  end

  private

  def render_with_summary
    render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: LINK_TABS)) do |switcher|
      switcher.with_summary { "Stat cards" }
      "Value panel"
    end
  end

  def summary_wrapper(page)
    page.children.find(&:element?).element_children.find { |part| part_name(part) == "summary" }
  end

  def drawn_order(page, width)
    parts = page.children.find(&:element?).element_children
    parts.each_with_index
      .sort_by { |part, index| [ order_at(part, width), index ] }
      .map { |part, _| part_name(part) }
  end

  def order_at(part, width)
    order = part["class"].to_s.split.filter_map { |name| name[/\A#{width}:(-?)order-(\d+)\z/] && "#{$1}#{$2}".to_i }.first
    order || 0
  end

  def part_name(part)
    return "tabs" if part.name == "nav" || part.at_css("button.ks-tab")
    return "summary" if part.text.include?("Stat cards")
    return "panel" if part.text.include?("Value panel")

    part.name
  end

  def render_with_panels
    render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: [ "Password", "Emailed code" ])) do |switcher|
      switcher.with_panel { '<input name="password" required>'.html_safe }
      switcher.with_panel { '<input name="code" required>'.html_safe }
    end
  end
end
