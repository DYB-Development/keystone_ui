# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::ModalComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_exposes_backdrop_classes
    component = Keystone::Ui::ModalComponent.new(title: "Details")

    assert_includes component.backdrop_classes, "fixed"
    assert_includes component.backdrop_classes, "inset-0"
    assert_includes component.backdrop_classes, "z-50"
  end

  def test_exposes_title
    component = Keystone::Ui::ModalComponent.new(title: "Event Payload")

    assert_equal "Event Payload", component.title
  end

  def test_defaults_to_md_size
    component = Keystone::Ui::ModalComponent.new(title: "X")

    assert_equal "max-w-lg", component.size_class
  end

  def test_accepts_sm_size
    component = Keystone::Ui::ModalComponent.new(title: "X", size: :sm)

    assert_equal "max-w-sm", component.size_class
  end

  def test_accepts_lg_size
    component = Keystone::Ui::ModalComponent.new(title: "X", size: :lg)

    assert_equal "max-w-2xl", component.size_class
  end

  def test_accepts_xl_size
    component = Keystone::Ui::ModalComponent.new(title: "X", size: :xl)

    assert_equal "max-w-4xl", component.size_class
  end

  def test_provides_stimulus_controller_data_for_open_close_behavior
    component = Keystone::Ui::ModalComponent.new(title: "Confirm")

    assert_equal "modal", component.wrapper_data[:controller]
  end

  def test_backdrop_classes_render_the_ks_modal_backdrop_class
    assert_includes Keystone::Ui::ModalComponent::BACKDROP_CLASSES, "ks-modal-backdrop"
  end

  def test_backdrop_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::ModalComponent::BACKDROP_CLASSES
  end

  def test_panel_classes_render_the_ks_modal_panel_class
    assert_includes Keystone::Ui::ModalComponent::PANEL_CLASSES, "ks-modal-panel"
  end

  def test_panel_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::ModalComponent::PANEL_CLASSES
  end

  def test_header_classes_render_the_ks_modal_header_class
    assert_includes Keystone::Ui::ModalComponent::HEADER_CLASSES, "ks-modal-header"
  end

  def test_header_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::ModalComponent::HEADER_CLASSES
  end

  def test_title_classes_render_the_ks_modal_title_class
    assert_includes Keystone::Ui::ModalComponent::TITLE_CLASSES, "ks-modal-title"
  end

  def test_title_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::ModalComponent::TITLE_CLASSES
  end

  def test_close_button_classes_render_the_ks_modal_close_class
    assert_includes Keystone::Ui::ModalComponent::CLOSE_BUTTON_CLASSES, "ks-modal-close"
  end

  def test_close_button_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::ModalComponent::CLOSE_BUTTON_CLASSES
  end
end
