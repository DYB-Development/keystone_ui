# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::BottomActionComponentRenderTest < ViewComponent::TestCase
  def test_labels_its_button_with_the_label_a_page_header_publishes
    page = render_after_page_header(title: "Events", action_url: "/events/new", action_label: "Create")

    assert_equal "Create", bottom_bar(page)&.at_css("a")&.text&.strip
  end

  private

  def render_after_page_header(**header)
    render_in_view_context do
      safe_join([ render(Keystone::Ui::PageHeaderComponent.new(**header)), render(Keystone::Ui::BottomActionComponent.new) ])
    end
  end

  def bottom_bar(page)
    page.at_css(".ks-bottom-action")
  end
end
