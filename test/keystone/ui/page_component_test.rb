# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::PageComponentTest < Minitest::Test
  def test_renders_the_shared_page_classes_for_each_option
    assert_equal "ks-page", Keystone::Ui::PageComponent.new.classes
    assert_equal "", Keystone::Ui::PageComponent.new(padding: :none).classes
    assert_equal "ks-page", Keystone::Ui::PageComponent.new(max_width: :full).classes
    %i[sm md lg xl].each do |width|
      assert_equal "ks-page ks-page-#{width}", Keystone::Ui::PageComponent.new(max_width: width).classes
    end
    %i[sm md lg xl].each do |offset|
      assert_equal "ks-page ks-page-offset-#{offset}", Keystone::Ui::PageComponent.new(top_offset: offset).classes
    end
  end

  def test_adds_the_classes_passed_for_one_use
    assert_equal "ks-page bg-gray-50", Keystone::Ui::PageComponent.new(class: "bg-gray-50").classes
  end
end
