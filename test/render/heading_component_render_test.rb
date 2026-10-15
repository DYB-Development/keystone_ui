# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::HeadingComponentRenderTest < ViewComponent::TestCase
  def test_shows_its_text_as_a_medium_heading
    page = render_inline(Keystone::Ui::HeadingComponent.new(text: "Work this month"))

    assert_equal "Work this month", page.css("h2.ks-heading.ks-heading-md").text.strip
  end

  def test_given_a_note_shows_it_beside_the_heading_in_one_row
    page = render_inline(Keystone::Ui::HeadingComponent.new(text: "Work", note: "12.5 billable hours"))

    assert_equal "12.5 billable hours", page.css(".ks-heading-row > h2.ks-heading + .ks-heading-note").text.strip
  end
end
