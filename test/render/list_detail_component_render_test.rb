# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ListDetailComponentRenderTest < ViewComponent::TestCase
  def test_with_no_detail_the_layout_is_one_column_at_every_width
    page = render_inline(Keystone::Ui::ListDetailComponent.new) { "Steps" }

    assert_equal [ "grid-cols-1" ], page.at_css("div.grid")&.[]("class").to_s.split.grep(/grid-cols/)
  end

  def test_the_detail_is_drawn_above_the_list
    page = render_inline(Keystone::Ui::ListDetailComponent.new) do |layout|
      layout.with_detail { "Step 2" }
      "Steps"
    end

    assert_equal [ "Step 2", "Steps" ], page.css("div.grid > div").map { |column| column.text.strip }
  end

  def test_with_a_detail_the_layout_splits_into_three_columns_at_lg
    page = render_inline(Keystone::Ui::ListDetailComponent.new) do |layout|
      layout.with_detail { "Step 2" }
      "Steps"
    end

    assert_includes page.at_css("div.grid")["class"].split, "lg:grid-cols-3"
  end

  def test_with_a_detail_the_list_moves_to_the_first_column_at_lg
    page = render_inline(Keystone::Ui::ListDetailComponent.new) do |layout|
      layout.with_detail { "Step 2" }
      "Steps"
    end

    assert_includes page.css("div.grid > div").last["class"].to_s.split, "lg:order-first"
  end

  def test_the_detail_takes_two_of_the_three_columns_at_lg
    page = render_inline(Keystone::Ui::ListDetailComponent.new) do |layout|
      layout.with_detail { "Step 2" }
      "Steps"
    end

    assert_includes page.css("div.grid > div").first["class"].to_s.split, "lg:col-span-2"
  end

  def test_the_list_and_the_detail_are_spaced_by_the_grid_layouts_medium_gap
    page = render_inline(Keystone::Ui::ListDetailComponent.new) { "Steps" }

    assert_includes page.at_css("div.grid")["class"].split, "ks-grid-gap-md"
  end

  def test_the_list_column_can_shrink_below_the_width_of_what_it_holds
    page = render_inline(Keystone::Ui::ListDetailComponent.new) { "Steps" }

    assert_includes page.at_css("div.grid > div")["class"].split, "min-w-0"
  end
end
