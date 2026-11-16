# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ReviewCardComponentRenderTest < ViewComponent::TestCase
  def test_shows_its_id_at_the_left_of_its_header_line
    page = render_card

    assert_equal "variant A", page.at_css(".ks-card > div:first-child > :first-child")&.text&.strip
  end

  private

  def render_card(**options)
    render_inline(Keystone::Ui::ReviewCardComponent.new(id: "variant A", title: "Fall catalog is here. 40 new pieces.", **options))
  end
end
