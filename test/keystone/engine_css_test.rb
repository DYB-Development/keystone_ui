# frozen_string_literal: true

require "test_helper"

class EngineCssTest < Minitest::Test
  def css
    @css ||= File.read(File.expand_path("../../app/assets/tailwind/keystone_ui_engine/engine.css", __dir__))
  end

  def test_contains_a_source_inline_safelist_with_grid_cols_classes
    assert_includes css, "@source inline("
    assert_includes css, "grid-cols-1"
    assert_includes css, "grid-cols-12"
    assert_includes css, "sm:grid-cols-1"
    assert_includes css, "lg:grid-cols-12"
  end
end
