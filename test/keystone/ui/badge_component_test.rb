# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::BadgeComponentTest < Minitest::Test
  def test_exposes_label
    component = Keystone::Ui::BadgeComponent.new(label: "Published")

    assert_equal "Published", component.label
  end

  def test_renders_the_shared_badge_classes_for_each_variant
    assert_equal "ks-badge ks-badge-neutral", Keystone::Ui::BadgeComponent.new(label: "X").classes
    %i[neutral success danger warning info].each do |variant|
      assert_equal "ks-badge ks-badge-#{variant}", Keystone::Ui::BadgeComponent.new(label: "X", variant: variant).classes
    end
  end

  def test_refuses_a_variant_it_does_not_have
    assert_raises(KeyError) { Keystone::Ui::BadgeComponent.new(label: "X", variant: :sparkly).classes }
  end

  def test_adds_the_classes_passed_for_one_use
    assert_equal "ks-badge ks-badge-neutral ml-2", Keystone::Ui::BadgeComponent.new(label: "X", class: "ml-2").classes
  end
end
