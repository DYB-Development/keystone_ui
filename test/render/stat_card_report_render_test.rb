# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::StatCardReportRenderTest < ViewComponent::TestCase
  def test_shows_a_note_under_its_value
    page = render_inline(Keystone::Ui::StatCardComponent.new(label: "Commits", value: "553", note: "excluding merge commits"))

    assert_equal "excluding merge commits", page.css(".ks-stat-card-value + .ks-stat-card-note").text.strip
  end
end
