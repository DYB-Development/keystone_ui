# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::InfoComponentTest < Minitest::Test
  def test_sits_level_with_the_text_beside_it
    assert_includes Keystone::Ui::InfoComponent.new(summary: "x").wrapper_classes.split, "align-middle"
  end
end
