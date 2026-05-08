# frozen_string_literal: true

require "test_helper"

class TailwindSafelistTest < Minitest::Test
  SKIP_CONSTANTS = %i[TYPE_MAP ELLIPSIS_ICON BACK_ICON CARET_ICON CLOSE_ICON COPY_ICON SORT_ASC_ICON SORT_DESC_ICON SORT_NEUTRAL_ICON COLUMNS_ICON UPLOAD_ICON].freeze

  def extract_classes_from_constants(klass)
    classes = []
    klass.constants(false).each do |const_name|
      next if SKIP_CONSTANTS.include?(const_name)

      value = klass.const_get(const_name)
      case value
      when String
        classes.concat(value.split)
      when Hash
        extract_classes_from_hash(value, classes)
      end
    end
    classes.uniq
  end

  def extract_classes_from_hash(hash, classes)
    hash.each_value do |v|
      case v
      when String then classes.concat(v.split)
      when Hash then extract_classes_from_hash(v, classes)
      end
    end
  end

  def all_constant_classes
    Keystone::Safelist::COMPONENTS.flat_map { |klass| extract_classes_from_constants(klass) }.uniq.sort
  end

  def test_is_auto_generated_from_component_constants
    missing = all_constant_classes - Keystone::SAFELIST.split

    assert_equal [], missing,
      "Classes in component constants but missing from SAFELIST:\n  #{missing.join("\n  ")}"
  end

  def test_includes_non_constant_classes_from_erb_templates_and_methods
    Keystone::Safelist::NON_CONSTANT_CLASSES.each do |css_class|
      assert_includes Keystone::SAFELIST, css_class,
        "NON_CONSTANT_CLASSES entry '#{css_class}' missing from SAFELIST"
    end
  end

  def test_components_lists_every_keystone_ui_component
    actual = Keystone::Ui.constants.filter_map { |c|
      klass = Keystone::Ui.const_get(c)
      klass if klass.is_a?(Class) && klass < ViewComponent::Base
    }.sort_by(&:name)

    listed = Keystone::Safelist::COMPONENTS.sort_by(&:name)

    assert_equal actual, listed,
      "Safelist::COMPONENTS is out of date. Missing: #{(actual - listed).map(&:name).join(', ')}"
  end
end
