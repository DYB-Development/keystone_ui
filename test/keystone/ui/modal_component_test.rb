# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::ModalComponentTest < Minitest::Test
  def test_exposes_backdrop_classes
    component = Keystone::Ui::ModalComponent.new(title: "Details")

    assert_includes component.backdrop_classes, "fixed"
    assert_includes component.backdrop_classes, "inset-0"
    assert_includes component.backdrop_classes, "z-50"
  end

  def test_exposes_panel_classes
    component = Keystone::Ui::ModalComponent.new(title: "Details")

    assert_includes component.panel_classes, "rounded-xl"
    assert_includes component.panel_classes, "border"
  end

  def test_exposes_title
    component = Keystone::Ui::ModalComponent.new(title: "Event Payload")

    assert_equal "Event Payload", component.title
  end

  def test_exposes_title_classes
    component = Keystone::Ui::ModalComponent.new(title: "X")

    assert_includes component.title_classes, "font-semibold"
  end

  def test_exposes_close_button_classes
    component = Keystone::Ui::ModalComponent.new(title: "X")

    assert_includes component.close_button_classes, "hover:text-gray-600"
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
end
