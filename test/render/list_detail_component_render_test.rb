# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ListDetailComponentRenderTest < ViewComponent::TestCase
  def test_with_no_detail_the_layout_is_one_column_at_every_width
    page = render_inline(Keystone::Ui::ListDetailComponent.new) { "Steps" }

    assert_equal [ "grid-cols-1" ], page.at_css("div.grid")&.[]("class").to_s.split.grep(/grid-cols/)
  end
end
