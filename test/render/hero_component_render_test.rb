# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::HeroComponentRenderTest < ViewComponent::TestCase
  def test_content_height_draws_the_hero_without_a_minimum_height
    page = render_inline(Keystone::Ui::HeroComponent.new(title: "Welcome", height: :content))

    refute_includes page.css("section.ks-hero").first["class"], "min-h-screen"
  end
end
