# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::NavigationComponentRenderTest < ViewComponent::TestCase
  def teardown
    KeystoneUi.reset_configuration!
  end

  def test_draws_the_page_content_a_layout_passes_below_the_top_bar
    declare_group("Sales", [ :quotes, "Quotes", "/quotes" ])

    page = render_navigation { "<p>Page</p>".html_safe }

    assert_equal "Page", page.at_css("nav ~ p")&.text
  end

  private

  def declare_group(label, *tabs)
    KeystoneUi.configure do |c|
      c.navigation_group(label) do |group|
        tabs.each { |key, tab_label, href, permitted = ->(_view) { true }| group.tab(key, label: tab_label, href: href, permitted: permitted) }
      end
    end
  end

  def render_navigation(&page_content)
    Nokogiri::HTML.fragment(vc_test_view_context.ui_navigation(&page_content))
  end
end
