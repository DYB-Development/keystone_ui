# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::CodeComponentTest < Minitest::Test
  def test_stores_language
    component = Keystone::Ui::CodeComponent.new(language: :ruby)

    assert_equal :ruby, component.language
  end
end
