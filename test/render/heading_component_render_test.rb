# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::HeadingComponentRenderTest < ViewComponent::TestCase
  def test_shows_its_text_as_a_medium_heading
    page = render_inline(Keystone::Ui::HeadingComponent.new(text: "Work this month"))

    assert_equal "Work this month", page.css("h2.ks-heading.ks-heading-md").text.strip
  end
end
