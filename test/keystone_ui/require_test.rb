# frozen_string_literal: true

require "test_helper"
require "rbconfig"

class KeystoneUi::RequireTest < Minitest::Test
  LIB = File.expand_path("../../lib", __dir__)

  def test_requiring_keystone_ui_loads_the_keystone_ui_styles_engine
    script = 'require "rails"; require "keystone_ui"; print defined?(KeystoneUi::Styles::Engine)'

    assert_equal "constant", IO.popen([ RbConfig.ruby, "-I", LIB, "-e", script ], err: File::NULL, &:read)
  end

  def test_requiring_keystone_ui_loads_the_theme_choice
    script = 'require "rails"; require "keystone_ui"; print defined?(KeystoneUi::ThemeChoice)'

    assert_equal "constant", IO.popen([ RbConfig.ruby, "-I", LIB, "-e", script ], err: File::NULL, &:read)
  end
end
