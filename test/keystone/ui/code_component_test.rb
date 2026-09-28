# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::CodeComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

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

  def test_pre_is_monospace_and_horizontally_scrollable
    classes = Keystone::Ui::CodeComponent.new.pre_classes

    assert_includes classes, "font-mono"
    assert_includes classes, "overflow-x-auto"
  end

  def test_wrapper_classes_render_the_ks_code_class
    assert_includes Keystone::Ui::CodeComponent::WRAPPER_CLASSES, "ks-code"
  end

  def test_wrapper_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::CodeComponent::WRAPPER_CLASSES
  end
end
