# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::BreadcrumbsComponentRenderTest < ViewComponent::TestCase
  TRAIL = [ [ "Holdings", "/holdings" ], [ "Resources", "/holdings/resources" ] ].freeze

  def test_links_each_step_of_the_trail
    page = render_inline(Keystone::Ui::BreadcrumbsComponent.new(trail: TRAIL))

    assert_equal [ "/holdings", "/holdings/resources" ], page.css("a").map { |link| link["href"] }
  end
end
