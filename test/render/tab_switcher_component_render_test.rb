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

  def test_a_summary_the_tab_row_and_the_panel_are_stacked_in_a_column_their_order_classes_apply_in
    wrapper = render_with_summary.children.find(&:element?)

    assert_equal %w[flex flex-col], wrapper["class"].to_s.split & %w[flex flex-col]
  end

  def test_following_a_link_tab_replaces_the_current_history_entry
    page = render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: LINK_TABS))

    assert_equal [ "replace", "replace" ], page.css("a.ks-tab").map { |link| link["data-turbo-action"] }
  end

  private

  def render_with_summary
    render_inline(Keystone::Ui::TabSwitcherComponent.new(tabs: LINK_TABS)) do |switcher|
      switcher.with_summary { "Stat cards" }
      "Value panel"
    end
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
    return "tabs" if part.name == "nav"
    return "summary" if part.text.include?("Stat cards")
    return "panel" if part.text.include?("Value panel")

    part.name
  end
end
