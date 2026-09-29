# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::BreadcrumbsComponentRenderTest < ViewComponent::TestCase
  TRAIL = [ [ "Holdings", "/holdings" ], [ "Resources", "/holdings/resources" ] ].freeze

  def test_links_each_step_of_the_trail
    page = render_inline(Keystone::Ui::BreadcrumbsComponent.new(trail: TRAIL))

    assert_equal [ "/holdings", "/holdings/resources" ], page.css("a").map { |link| link["href"] }
  end

  def test_names_each_step_by_its_label
    page = render_inline(Keystone::Ui::BreadcrumbsComponent.new(trail: TRAIL))

    assert_equal [ "Holdings", "Resources" ], page.css("a").map { |link| link.text.strip }
  end

  def test_ends_with_the_current_page_marked_and_not_linked
    page = render_inline(Keystone::Ui::BreadcrumbsComponent.new(trail: TRAIL, current: "New person"))

    assert_equal "New person", page.css("[aria-current=page]:not(a)").text.strip
  end

  def test_is_named_as_breadcrumbs_for_screen_readers
    page = render_inline(Keystone::Ui::BreadcrumbsComponent.new(trail: TRAIL))

    assert_equal "Breadcrumb", page.css("nav").attr("aria-label")&.value
  end

  def test_separates_each_step_from_the_next_out_of_sight_of_screen_readers
    page = render_inline(Keystone::Ui::BreadcrumbsComponent.new(trail: TRAIL, current: "New person"))

    assert_equal [ "›", "›" ], page.css("[aria-hidden=true]").map { |separator| separator.text.strip }
  end

  def test_is_shown_only_from_large_screens_where_the_mobile_header_is_hidden
    page = render_inline(Keystone::Ui::BreadcrumbsComponent.new(trail: TRAIL))

    assert_equal [ "hidden", "lg:block" ], page.css("nav").attr("class")&.value.to_s.split & [ "hidden", "lg:block" ]
  end

  def test_uses_the_muted_style_of_the_back_links
    page = render_inline(Keystone::Ui::BreadcrumbsComponent.new(trail: TRAIL))

    assert_includes page.css("nav").attr("class")&.value.to_s.split, "ks-mobile-header-back"
  end
end
