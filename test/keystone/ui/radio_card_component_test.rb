# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::RadioCardComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_exposes_label
    component = Keystone::Ui::RadioCardComponent.new(name: "need", value: "now", label: "Right now")

    assert_equal "Right now", component.label
  end

  def test_exposes_name_and_value
    component = Keystone::Ui::RadioCardComponent.new(name: "need", value: "now", label: "Right now")

    assert_equal "need", component.name
    assert_equal "now", component.value
  end

  def test_defaults_checked_to_false
    component = Keystone::Ui::RadioCardComponent.new(name: "need", value: "now", label: "Right now")

    assert_equal false, component.checked?
  end

  def test_reflects_checked_when_set
    component = Keystone::Ui::RadioCardComponent.new(name: "need", value: "now", label: "Right now", checked: true)

    assert_equal true, component.checked?
  end

  def test_exposes_hint
    component = Keystone::Ui::RadioCardComponent.new(name: "need", value: "now", label: "Right now", hint: "current jobs")

    assert_equal "current jobs", component.hint
  end

  def test_has_no_hint_by_default
    component = Keystone::Ui::RadioCardComponent.new(name: "need", value: "now", label: "Right now")

    assert_equal false, component.hint?
  end

  def test_indicates_hint_present
    component = Keystone::Ui::RadioCardComponent.new(name: "need", value: "now", label: "Right now", hint: "current jobs")

    assert_equal true, component.hint?
  end

  def test_hint_classes_mute_text
    component = Keystone::Ui::RadioCardComponent.new(name: "need", value: "now", label: "Right now", hint: "current jobs")

    assert_includes component.hint_classes, "text-surface-500"
  end

  def test_card_classes_size_to_their_content
    component = Keystone::Ui::RadioCardComponent.new(name: "need", value: "now", label: "Right now")

    assert_includes component.classes, "inline-flex"
  end

  def test_base_classes_render_the_ks_radio_card_class
    assert_includes Keystone::Ui::RadioCardComponent::BASE_CLASSES, "ks-radio-card"
  end

  def test_base_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::RadioCardComponent::BASE_CLASSES
  end

  def test_highlight_classes_render_the_ks_radio_card_highlight_class
    assert_includes Keystone::Ui::RadioCardComponent::HIGHLIGHT_CLASSES, "ks-radio-card-highlight"
  end

  def test_highlight_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::RadioCardComponent::HIGHLIGHT_CLASSES
  end

  def test_label_classes_render_the_ks_radio_card_label_class
    assert_includes Keystone::Ui::RadioCardComponent::LABEL_CLASSES, "ks-radio-card-label"
  end

  def test_label_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::RadioCardComponent::LABEL_CLASSES
  end

  def test_hint_classes_render_the_ks_radio_card_hint_class
    assert_includes Keystone::Ui::RadioCardComponent::HINT_CLASSES, "ks-radio-card-hint"
  end
end
