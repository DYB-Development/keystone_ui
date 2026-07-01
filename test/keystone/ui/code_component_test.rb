# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::CodeComponentTest < Minitest::Test
  def test_stores_language
    component = Keystone::Ui::CodeComponent.new(language: :ruby)

    assert_equal :ruby, component.language
  end

  def test_reports_caption_presence
    assert Keystone::Ui::CodeComponent.new(caption: "db/schema.rb").caption?
    refute Keystone::Ui::CodeComponent.new.caption?
  end

  def test_builds_a_language_class_from_the_language
    assert_equal "language-ruby", Keystone::Ui::CodeComponent.new(language: :ruby).language_class
  end

  def test_language_class_is_nil_without_a_language
    assert_nil Keystone::Ui::CodeComponent.new.language_class
  end
end
