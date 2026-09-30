# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::ActionMenuComponentTest < Minitest::Test
  def test_shows_on_every_screen_size
    refute_match(/\blg:hidden\b/, Keystone::Ui::ActionMenuComponent::WRAPPER_CLASSES)
  end
end
